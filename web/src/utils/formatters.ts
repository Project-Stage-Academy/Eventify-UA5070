export const formatDate = (dateString: string) =>
  new Date(dateString).toLocaleString("en-GB", {
    day: "2-digit",
    month: "short",
    hour: "2-digit",
    minute: "2-digit",
  });


  export function parsePrice(priceString: string): number {
    return parseFloat(priceString);
  }
  
  export function formatPrice(price: string | number): string {
    const numPrice = typeof price === "string" ? parseFloat(price) : price;
    return numPrice.toFixed(2);
  }
  