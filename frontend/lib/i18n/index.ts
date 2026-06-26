import { ja } from './ja';
import { en } from './en';
import { fr } from './fr';
import { zh } from './zh';
import { ru } from './ru';
import { es } from './es';
import { ar } from './ar';
import type { Translations } from './ja';

export type Locale = 'ja' | 'en' | 'fr' | 'zh' | 'ru' | 'es' | 'ar';

const translations: Record<Locale, Translations> = { ja, en, fr, zh, ru, es, ar };

export function getTranslations(locale: Locale): Translations {
  return translations[locale] ?? translations.ja;
}

export const LOCALES: Locale[] = ['ja', 'en', 'fr', 'zh', 'ru', 'es', 'ar'];
export const LOCALE_LABELS: Record<Locale, string> = {
  ja: '日本語',
  en: 'English',
  fr: 'Français',
  zh: '中文',
  ru: 'Русский',
  es: 'Español',
  ar: 'العربية',
};
