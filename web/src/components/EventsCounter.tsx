type EventsCounterProps = {
  count: number;
};

export function EventsCounter({ count }: EventsCounterProps) {
  return (
    <div className="bg-white border-2 border-slate-900 rounded-lg px-6 py-3 min-w-[140px] text-center font-bold">
      <div className="text-sm text-slate-600 mb-1">Events:</div>
      <div className="text-3xl text-slate-900">{count}</div>
    </div>
  );
}

