import { Button } from "./ui/Button";

type FiltersProps = {
  onFiltersClick: () => void;
};

export function Filters({ onFiltersClick }: FiltersProps) {
  return (
    <Button
      variant="tertiary"
      onClick={onFiltersClick}
      className="px-8 py-3 text-base font-semibold"
    >
      filters
    </Button>
  );
}

