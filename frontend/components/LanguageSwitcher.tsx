'use client';

import { useRouter } from 'next/navigation';
import type { Locale } from '@/lib/i18n';
import { LOCALES, LOCALE_LABELS } from '@/lib/i18n';

interface Props {
  currentLocale: Locale;
}

export default function LanguageSwitcher({ currentLocale }: Props) {
  const router = useRouter();

  function handleChange(locale: Locale) {
    document.cookie = `locale=${locale}; path=/; max-age=31536000`;
    router.refresh();
  }

  return (
    <div className="flex flex-wrap gap-1">
      {LOCALES.map((locale) => (
        <button
          key={locale}
          onClick={() => handleChange(locale)}
          className={`px-2 py-1 text-xs rounded transition-colors ${
            locale === currentLocale
              ? 'bg-[#2a52cc] text-white font-semibold'
              : 'bg-[#16161a] text-gray-400 hover:text-white hover:bg-gray-700'
          }`}
          aria-current={locale === currentLocale ? 'true' : undefined}
        >
          {LOCALE_LABELS[locale]}
        </button>
      ))}
    </div>
  );
}
