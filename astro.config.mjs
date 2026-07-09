import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  site: 'https://alusoreza.github.io',
  outDir: 'dist',
  publicDir: 'public',

  vite: {
    plugins: [tailwindcss()],
  },
});