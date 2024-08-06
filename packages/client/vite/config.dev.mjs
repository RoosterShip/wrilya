import { defineConfig } from 'vite';

export default defineConfig({
    base: './',
    build: {
        rollupOptions: {
            output: {
                manualChunks: {
                    phaser: ['phaser']
                }
            }
        },
    },
    server: {
        port: 8080
    },
    define: {
        __BUILD__: JSON.stringify('DEV'),
        __CHAIN_ID__: JSON.stringify('31337'),
        __SERVER__: JSON.stringify('http://localhost:4000')
    }
});
