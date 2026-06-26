import { cookies } from 'next/headers';
import { notFound } from 'next/navigation';
import { getTranslations, type Locale } from '@/lib/i18n';
import { getItinerary } from '@/lib/api';
import ItineraryResult from '@/components/ItineraryResult';

interface PageProps {
  params: Promise<{ id: string }>;
}

export default async function ResultPage({ params }: PageProps) {
  const { id } = await params;
  const cookieStore = await cookies();
  const locale = (cookieStore.get('locale')?.value ?? 'ja') as Locale;
  const t = getTranslations(locale);

  const itineraryId = parseInt(id, 10);
  if (isNaN(itineraryId)) notFound();

  let itinerary;
  try {
    itinerary = await getItinerary(itineraryId);
  } catch {
    notFound();
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-white">{t.yourItinerary}</h1>
      </div>
      <ItineraryResult itinerary={itinerary} t={t} />
    </div>
  );
}
