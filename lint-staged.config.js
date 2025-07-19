export default {
  'src/**/*.{js,ts,jsx,tsx}': 'bunx biome check --write',
  'test/**/*.{js,ts,jsx,tsx}': 'bunx biome check --write',
  '**/*.ts?(x)': () => 'tsc -p tsconfig.json --noEmit',
}