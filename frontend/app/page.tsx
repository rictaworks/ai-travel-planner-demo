import { cookies } from 'next/headers';
import { getTranslations, type Locale } from '@/lib/i18n';
import PlannerForm from '@/components/PlannerForm';

export default async function HomePage() {
  const cookieStore = await cookies();
  const locale = (cookieStore.get('locale')?.value ?? 'ja') as Locale;
  const t = getTranslations(locale);

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-white">{t.title}</h1>
        <p className="text-gray-400 mt-1">{t.subtitle}</p>
      </div>
      <PlannerForm t={t} />
    </div>
  );
}
