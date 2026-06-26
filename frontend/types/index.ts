export type Weather = 'sunny' | 'cloudy' | 'rainy' | 'snowy';
export type Category = 'nature' | 'gourmet' | 'historical' | 'shopping' | 'activity' | 'relax';
export type TimeSlot = 'morning' | 'lunch' | 'afternoon' | 'dinner';

export interface Preference {
  category: Category;
  priority: number;
}

export interface PlannerInput {
  trip_days: number;
  budget_total: number;
  preferences: Preference[];
  expected_weather: Weather;
  honeypot: string;
}

export interface ItineraryItem {
  spot_id: number;
  spot_name: string;
  category: Category;
  time_slot: TimeSlot;
  cost: number;
  duration_min: number;
}

export interface ItineraryDay {
  day_number: number;
  items: ItineraryItem[];
}

export interface Itinerary {
  id: number;
  status: string;
  trip_days: number;
  budget_total: number;
  expected_weather: Weather;
  fallback?: boolean;
  days: ItineraryDay[];
}

export interface ApiError {
  error: string;
  message: string;
}
