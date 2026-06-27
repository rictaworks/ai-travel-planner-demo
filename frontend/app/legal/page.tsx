import Link from 'next/link';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: '利用規約・免責事項・連絡先 | AI旅行プランナー',
};

export default function LegalPage() {
  return (
    <div className="space-y-10 text-sm text-gray-300 leading-relaxed">
      <div>
        <Link href="/" className="text-[#2a52cc] hover:underline text-xs">
          ← 旅行プランナーに戻る
        </Link>
      </div>

      {/* 利用規約 */}
      <section>
        <h2 className="text-lg font-bold text-white mb-4 pb-2 border-b border-gray-700">
          利用規約
        </h2>
        <ul className="space-y-3 list-disc list-inside">
          <li>本サービスはデモンストレーション目的のみで提供されます。商用利用・再配布は禁止します。</li>
          <li>サービスの内容は予告なく変更・停止する場合があります。</li>
          <li>生成された旅程データは毎日 JST 03:00 に自動削除されます。</li>
          <li>本サービスの利用に際し、本規約に同意したものとみなします。</li>
        </ul>
      </section>

      {/* 免責事項 */}
      <section>
        <h2 className="text-lg font-bold text-white mb-4 pb-2 border-b border-gray-700">
          免責事項
        </h2>
        <ul className="space-y-3 list-disc list-inside">
          <li>提示される旅程・スポット名・料金はデモ用のサンプルデータです。実際の観光情報・価格を保証するものではありません。</li>
          <li>本サービスの利用により生じた損害について、Ricta Works は一切の責任を負いません。</li>
          <li>サービスの可用性・正確性・継続性を保証しません。</li>
        </ul>
      </section>

      {/* 連絡先 */}
      <section>
        <h2 className="text-lg font-bold text-white mb-4 pb-2 border-b border-gray-700">
          連絡先
        </h2>
        <dl className="space-y-2">
          <div className="flex gap-4">
            <dt className="w-20 shrink-0 text-gray-500">屋号</dt>
            <dd>Ricta Works</dd>
          </div>
          <div className="flex gap-4">
            <dt className="w-20 shrink-0 text-gray-500">住所</dt>
            <dd>〒190-0022 東京都立川市錦町1丁目4-20 TSCビル5階</dd>
          </div>
          <div className="flex gap-4">
            <dt className="w-20 shrink-0 text-gray-500">電話</dt>
            <dd>070-5148-0380</dd>
          </div>
          <div className="flex gap-4">
            <dt className="w-20 shrink-0 text-gray-500">メール</dt>
            <dd>
              <a href="mailto:info@rictaworks.jp" className="text-[#2a52cc] hover:underline">
                info@rictaworks.jp
              </a>
            </dd>
          </div>
          <div className="flex gap-4">
            <dt className="w-20 shrink-0 text-gray-500">Web</dt>
            <dd>
              <a href="https://rictaworks.jp" target="_blank" rel="noopener noreferrer" className="text-[#2a52cc] hover:underline">
                https://rictaworks.jp
              </a>
            </dd>
          </div>
          <div className="flex gap-4">
            <dt className="w-20 shrink-0 text-gray-500">X</dt>
            <dd>
              <a href="https://x.com/rictaworks" target="_blank" rel="noopener noreferrer" className="text-[#2a52cc] hover:underline">
                @rictaworks
              </a>
            </dd>
          </div>
          <div className="flex gap-4">
            <dt className="w-20 shrink-0 text-gray-500">GitHub</dt>
            <dd>
              <a href="https://github.com/rictaworks" target="_blank" rel="noopener noreferrer" className="text-[#2a52cc] hover:underline">
                github.com/rictaworks
              </a>
            </dd>
          </div>
        </dl>
      </section>
    </div>
  );
}
