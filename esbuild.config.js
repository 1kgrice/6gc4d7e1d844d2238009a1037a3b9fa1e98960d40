const esbuild = require('esbuild')
const postCssPlugin = require('esbuild-plugin-postcss2').default
const sassPlugin = require('esbuild-plugin-sass')
const path = require('path')

esbuild
  .context({
    entryPoints: [path.join(__dirname, 'app/javascript/entrypoints/*.*')],
    bundle: true,
    sourcemap: true,
    publicPath: '/assets/',
    outdir: path.join(__dirname, 'app/assets/builds'),
    absWorkingDir: path.join(__dirname, 'app/javascript'),
    assetNames: '[name]-[hash].digested',
    minify: process.argv.includes('--minify'),
    logLevel: 'info', // 'debug', 'info', 'warning', 'error', 'silent'
    plugins: [
      sassPlugin(),
      postCssPlugin({
        plugins: [
          require('postcss-import'),
          require('tailwindcss/nesting'),
          require('tailwindcss'),
          require('autoprefixer')
        ]
      })
    ],
    loader: {
      '.js': 'jsx',
      '.ts': 'tsx',
      '.png': 'file',
      '.jpg': 'file',
      '.gif': 'file',
      '.svg': 'file',
      '.webp': 'file',
      '.woff': 'file',
      '.woff2': 'file',
      '.ttf': 'file',
      '.eot': 'file'
    },
    define: {
      'process.env.APP_ENV': JSON.stringify(process.env.RAILS_ENV || 'development'),
      'process.env.API_HOST': JSON.stringify(process.env.API_HOST || `localhost:${3000}`),
      'process.env.API_VERSION': JSON.stringify(process.env.API_VERSION || 'v1'),
      'process.env.DISCOVER_URL': JSON.stringify(
        process.env.DISCOVER_URL || `http://discover.localhost:${3000}`
      )
    }
  })
  .then((context) => {
    if (process.argv.includes('--watch')) {
      context.watch()
    } else {
      context.rebuild().then((result) => {
        context.dispose()
      })
    }
  })
  .catch(() => process.exit(1))
