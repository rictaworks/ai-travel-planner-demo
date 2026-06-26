import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
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
        <header className="sticky top-0 z-50 border-b border-gray-800" style={{ backgroundColor: 'rgba(10,10,14,0.95)' }}>
          <div className="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
            <span className="font-bold text-lg tracking-tight">{t.title}</span>
            <LanguageSwitcher currentLocale={locale} />
          </div>
        </header>
        <main className="max-w-2xl mx-auto px-4 py-8">
          {children}
        </main>
      </body>
    </html>
  );
}
