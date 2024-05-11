# Intrucciones para ejecutar el front

- Dirigirse a la carpeta de la aplicacion:
  ```
  cd money-organizer-app
  ```
- Ejecutar los siguientes comandos
  ```
  npm install
  npm run dev
  ```

  Con eso la aplicacion se ejecuta en http://localhost:5173/

<b>Aclaracion</b>: Dentro del vite.config.ts, se agrego lo siguiente dentro del defineConfig para habilitar el HMR en windows con WSL:
```
  server: {
    watch: {
      usePolling: true
    }
  }
```
De no ser el caso, puede removerse y deberia funcionar igual





# React + TypeScript + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react/README.md) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type aware lint rules:

- Configure the top-level `parserOptions` property like this:

```js
export default {
  // other rules...
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    project: ['./tsconfig.json', './tsconfig.node.json'],
    tsconfigRootDir: __dirname,
  },
}
```

- Replace `plugin:@typescript-eslint/recommended` to `plugin:@typescript-eslint/recommended-type-checked` or `plugin:@typescript-eslint/strict-type-checked`
- Optionally add `plugin:@typescript-eslint/stylistic-type-checked`
- Install [eslint-plugin-react](https://github.com/jsx-eslint/eslint-plugin-react) and add `plugin:react/recommended` & `plugin:react/jsx-runtime` to the `extends` list
