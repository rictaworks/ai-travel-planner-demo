import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import Link from 'next/link';
import LanguageSwitcher from '@/components/LanguageSwitcher';
import { getTranslations, type Locale } from '@/lib/i18n';
import { cookies } from 'next/headers';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'AI Travel Planner',
  description: 'Generate your travel itinerary automatically with AI',
};

export default async function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const cookieStore = await cookies();
  const locale = (cookieStore.get('locale')?.value ?? 'ja') as Locale;
  const t = getTranslations(locale);

  return (
    <html lang={locale} dir={locale === 'ar' ? 'rtl' : 'ltr'}>
      <body className={`${inter.className} min-h-screen`} style={{ backgroundColor: '#0c0c0e', color: '#ffffff' }}>
        {/* アンバーバナー */}
        <div className="w-full bg-amber-500 text-black text-center text-xs py-2 px-4 font-medium">
          これはデモ版です。データはサーバー再起動時にリセットされる場合があります。
        </div>
        <header className="sticky top-0 z-50 border-b border-gray-800" style={{ backgroundColor: 'rgba(10,10,14,0.95)' }}>
          <div className="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
            <span className="font-bold text-lg tracking-tight">{t.title}</span>
            <div className="flex items-center gap-4">
              <Link
                href="https://rictaworks.jp/#demos"
                className="text-xs text-gray-400 hover:text-white transition-colors border-l border-gray-700 pl-4"
              >
                ← デモ一覧へ
              </Link>
              <LanguageSwitcher currentLocale={locale} />
            </div>
          </div>
        </header>
        <main className="max-w-2xl mx-auto px-4 py-8">
          {children}
        </main>
        <footer className="border-t border-gray-800 mt-4">
          <div className="max-w-2xl mx-auto px-4 py-4 text-center">
            <Link href="/legal" className="text-xs text-gray-600 hover:text-gray-400 transition-colors">
              利用規約・免責事項・連絡先
            </Link>
          </div>
        </footer>
        {/* 右下固定ご相談ボタン */}
        <a
          href="https://rictaworks.jp/"
          target="_blank"
          rel="noopener noreferrer"
          className="fixed bottom-6 right-6 z-50 flex items-center gap-2 px-4 py-3 rounded-full text-white text-sm font-medium shadow-lg transition-colors"
          style={{ backgroundColor: '#2a52cc' }}
        >
          <span>💬</span>
          <span>ご相談はこちら</span>
        </a>
      </body>
    </html>
  );
}
