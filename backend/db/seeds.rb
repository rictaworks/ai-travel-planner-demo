# This file should ensure the existence of records required to run the application in every environment.
# The code here is idempotent so that it can be executed at any point in every environment.

Rails.logger.info("Starting seed data load...")

tokyo = Region.find_or_create_by!(name: "東京エリア")

spots_data = [
  # nature: 2 spots
  {
    region: tokyo,
    name: "上野恩賜公園",
    category: "nature",
    cost: 0,
    duration_min: 90,
    indoor_outdoor: "outdoor",
    description: "東京都台東区にある広大な公園。桜の名所として知られ、上野動物園や複数の美術館・博物館を擁する。"
  },
  {
    region: tokyo,
    name: "新宿御苑",
    category: "nature",
    cost: 500,
    duration_min: 120,
    indoor_outdoor: "outdoor",
    description: "新宿区と渋谷区にまたがる国民公園。フランス式整形庭園・イギリス式風景庭園・日本庭園の3つの庭園様式を持つ。"
  },
  # gourmet: 4 spots
  {
    region: tokyo,
    name: "築地場外市場",
    category: "gourmet",
    cost: 2000,
    duration_min: 60,
    indoor_outdoor: "either",
    description: "東京都中央区にある市場。新鮮な海産物・食材・調理器具などを販売する店舗が並ぶ。"
  },
  {
    region: tokyo,
    name: "浅草グルメ横丁",
    category: "gourmet",
    cost: 1500,
    duration_min: 90,
    indoor_outdoor: "either",
    description: "浅草エリアの食べ歩きスポット。もんじゃ焼き・天ぷら・どじょう鍋など江戸の味を楽しめる。"
  },
  {
    region: tokyo,
    name: "渋谷フードコート",
    category: "gourmet",
    cost: 1200,
    duration_min: 60,
    indoor_outdoor: "indoor",
    description: "渋谷駅周辺のショッピングモール内にあるフードコート。多様なジャンルの飲食店が集まる。"
  },
  {
    region: tokyo,
    name: "上野アメ横グルメ",
    category: "gourmet",
    cost: 1000,
    duration_min: 60,
    indoor_outdoor: "outdoor",
    description: "上野駅近くのアメ横商店街での食べ歩き。海産物・ドライフルーツ・スイーツなど多彩な食を楽しめる。"
  },
  # historical: 3 spots
  {
    region: tokyo,
    name: "浅草寺",
    category: "historical",
    cost: 0,
    duration_min: 90,
    indoor_outdoor: "outdoor",
    description: "東京都台東区浅草にある都内最古の寺院。雷門・仲見世通り・本堂が有名な観光スポット。"
  },
  {
    region: tokyo,
    name: "東京国立博物館",
    category: "historical",
    cost: 1000,
    duration_min: 120,
    indoor_outdoor: "indoor",
    description: "上野公園内にある日本最大の博物館。日本と東洋の美術・文化財を収蔵・展示する。"
  },
  {
    region: tokyo,
    name: "江戸東京博物館",
    category: "historical",
    cost: 600,
    duration_min: 90,
    indoor_outdoor: "indoor",
    description: "東京都墨田区にある江戸東京の歴史と文化を学べる博物館。実物大の復元模型が見どころ。"
  },
  # shopping: 2 spots
  {
    region: tokyo,
    name: "原宿竹下通り",
    category: "shopping",
    cost: 3000,
    duration_min: 120,
    indoor_outdoor: "outdoor",
    description: "原宿駅近くにある若者文化の発信地。個性的なファッション・雑貨・クレープなどの店舗が立ち並ぶ。"
  },
  {
    region: tokyo,
    name: "銀座ショッピング",
    category: "shopping",
    cost: 5000,
    duration_min: 120,
    indoor_outdoor: "either",
    description: "東京を代表する高級ショッピング街。国内外のブランド旗艦店や百貨店が集積する。"
  },
  # activity: 2 spots
  {
    region: tokyo,
    name: "東京スカイツリー",
    category: "activity",
    cost: 2100,
    duration_min: 90,
    indoor_outdoor: "indoor",
    description: "東京都墨田区にある世界最高水準の電波塔。展望台からは東京の全景を一望できる。"
  },
  {
    region: tokyo,
    name: "お台場観光",
    category: "activity",
    cost: 500,
    duration_min: 120,
    indoor_outdoor: "outdoor",
    description: "東京湾に浮かぶ人工島。レインボーブリッジ・自由の女神像・ショッピングモールなどの観光スポットが集まる。"
  },
  # relax: 2 spots
  {
    region: tokyo,
    name: "皇居東御苑",
    category: "relax",
    cost: 0,
    duration_min: 90,
    indoor_outdoor: "outdoor",
    description: "皇居の東側に位置する庭園。旧江戸城の本丸・二の丸・三の丸の一部を整備した自然豊かな公園。"
  },
  {
    region: tokyo,
    name: "六本木ヒルズ展望台",
    category: "relax",
    cost: 1800,
    duration_min: 60,
    indoor_outdoor: "indoor",
    description: "六本木ヒルズ森タワー52階にある東京シティビュー。東京の夜景を楽しめる人気の展望施設。"
  }
]

spots_data.each do |attrs|
  Spot.find_or_create_by!(name: attrs[:name], region: attrs[:region]) do |spot|
    spot.category       = attrs[:category]
    spot.cost           = attrs[:cost]
    spot.duration_min   = attrs[:duration_min]
    spot.indoor_outdoor = attrs[:indoor_outdoor]
    spot.description    = attrs[:description]
  end
end

Rails.logger.info("Seed data load complete. Regions: #{Region.count}, Spots: #{Spot.count}")
