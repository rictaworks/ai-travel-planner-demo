require "rails_helper"

RSpec.describe "Itineraries API", type: :request do
  let(:region) { create(:region) }

  # Build a minimal spot set so the generator can return a result
  before do
    create(:spot, :nature, :outdoor, region: region, name: "自然spot", cost: 0, duration_min: 60)
    create(:spot, :gourmet, :indoor, region: region, name: "グルメspot", cost: 500, duration_min: 60)
    create(:spot, :historical, :indoor, region: region, name: "歴史spot", cost: 300, duration_min: 60)
  end

  let(:valid_params) do
    {
      itinerary: {
        trip_days:        1,
        budget_total:     10000,
        expected_weather: "sunny",
        preferences:      ["nature"],
        honeypot:         ""
      }
    }
  end

  describe "POST /itineraries" do
    context "正常リクエスト" do
      it "201 を返し旅程 JSON を含む" do
        post "/itineraries", params: valid_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["id"]).to be_present
        expect(json["days"]).to be_a(Array)
      end

      it "旅程がデータベースに保存される" do
        expect {
          post "/itineraries", params: valid_params, as: :json
        }.to change(Itinerary, :count).by(1)
      end

      it "生成された旅程に ItineraryDay が含まれる" do
        post "/itineraries", params: valid_params, as: :json
        json = JSON.parse(response.body)
        expect(json["days"].size).to eq(valid_params[:itinerary][:trip_days])
      end
    end

    context "ハニーポット検証" do
      it "honeypot フィールドに値が入っている場合は 422 を返す" do
        params_with_honeypot = valid_params.deep_merge(itinerary: { honeypot: "bot-value" })

        post "/itineraries", params: params_with_honeypot, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("invalid_request")
      end

      it "itinerary がデータベースに保存されない" do
        params_with_honeypot = valid_params.deep_merge(itinerary: { honeypot: "bot-value" })

        expect {
          post "/itineraries", params: params_with_honeypot, as: :json
        }.not_to change(Itinerary, :count)
      end
    end

    context "予算超過で生成不可の場合" do
      it "422 と error: no_plan_available を返す" do
        # Make all spots expensive
        Spot.all.each { |s| s.update!(cost: 99999) }

        post "/itineraries", params: valid_params.deep_merge(itinerary: { budget_total: 1 }), as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("no_plan_available")
      end
    end

    context "セッション管理" do
      it "Cookie に owner_session_id が設定される" do
        post "/itineraries", params: valid_params, as: :json

        # Cookie header should contain session cookie
        expect(response.cookies).to have_key("_ai_travel_session").or(
          satisfy { response.headers["Set-Cookie"].present? }
        )
      end

      it "同じセッションから連続リクエストすると owner_session_id が同一になる" do
        post "/itineraries", params: valid_params, as: :json
        expect(response).to have_http_status(:created)
        first_id = Itinerary.last.owner_session_id

        post "/itineraries", params: valid_params, as: :json
        expect(response).to have_http_status(:created)
        second_id = Itinerary.last.owner_session_id

        expect(first_id).to eq(second_id)
      end
    end
  end

  describe "GET /itineraries/:id" do
    context "存在する旅程への正常アクセス" do
      it "200 と旅程 JSON を返す" do
        post "/itineraries", params: valid_params, as: :json
        expect(response).to have_http_status(:created)
        itinerary_id = JSON.parse(response.body)["id"]

        get "/itineraries/#{itinerary_id}", as: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["id"]).to eq(itinerary_id)
        expect(json["days"]).to be_a(Array)
      end
    end

    context "セッションをまたいだアクセス（スコーピング）" do
      it "別 owner_session_id を持つ旅程には 404 が返る" do
        # Directly create an itinerary owned by a different session
        other_itinerary = create(:itinerary, owner_session_id: "completely-different-session-xyz")

        # Access with current session (has a different session ID)
        get "/itineraries/#{other_itinerary.id}", as: :json

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("not_found")
      end
    end

    context "存在しない ID" do
      it "404 を返す" do
        get "/itineraries/99999999", as: :json

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "ハードコード検出テスト" do
    it "POST レスポンスの status はモデル定数 STATUSES に含まれる値である" do
      post "/itineraries", params: valid_params, as: :json
      json = JSON.parse(response.body)
      expect(Itinerary::STATUSES).to include(json["status"])
    end

    it "weather パラメータはモデル定数 WEATHER_OPTIONS に含まれる値のみ受け付ける" do
      # Itinerary model validation enforces this
      invalid_params = valid_params.deep_merge(itinerary: { expected_weather: "typhoon" })
      post "/itineraries", params: invalid_params, as: :json
      # The model validation should cause the generator to fail or return an error
      # The key assertion: no itinerary with invalid weather should be persisted
      expect(Itinerary.where(expected_weather: "typhoon")).to be_empty
    end
  end
end
