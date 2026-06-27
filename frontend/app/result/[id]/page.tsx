'use client';

import { useEffect, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { getTranslations, type Locale } from '@/lib/i18n';
import type { Translations } from '@/lib/i18n/ja';
import ItineraryResult from '@/components/ItineraryResult';
import type { Itinerary } from '@/types';

export default function ResultPage() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const [itinerary, setItinerary] = useState<Itinerary | null>(null);
  const [t, setT] = useState<Translations | null>(null);

  useEffect(() => {
    const match = document.cookie.match(/(?:^|;\s*)locale=([^;]+)/);
    const locale = (match?.[1] as Locale) ?? 'ja';
    setT(getTranslations(locale));

    const raw = sessionStorage.getItem(`itinerary_${params.id}`);
    if (raw) {
      setItinerary(JSON.parse(raw));
    } else {
      router.replace('/');
    }
  }, [params.id, router]);

  if (!itinerary || !t) {
    return (
      <div className="flex items-center justify-center min-h-[50vh]">
        <div className="text-gray-400">読み込み中...</div>
      </div>
    );
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
