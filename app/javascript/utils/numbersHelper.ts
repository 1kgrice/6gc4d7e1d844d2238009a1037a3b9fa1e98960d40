export function formatNumberToKorM(number: number): string {
  if (number < 1000) {
    return number.toString();
  }
  if (number < 1_000_000) {
    return Math.floor(number / 1000) + 'K';
  }
  return Math.floor(number / 1000000) + 'M';
}