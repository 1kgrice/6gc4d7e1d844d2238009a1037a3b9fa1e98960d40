module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.{css,scss}',
    './app/javascript/**/*.{jsx,tsx}'
  ],
  theme: {
    extend: {
      fontFamily: {
        'mabry-pro': ['Mabry Pro', 'sans-serif']
      },
      colors: {
        // Standard
        black: '#000000',
        white: '#ffffff',
        // Gumroad base
        pink: '#ff90e7',
        yellow: '#f2f333',
        'dark-yellow': '#ffc900',
        teal: '#22a094',
        purple: '#90a8ed',
        brown: '#98282b',
        orange: '#fe7151',
        'dark-orange': '#e2432e',
        alto: '#dddddd',
        grey: '#d7d3d2',
        cream: '#f4f4f1',
        ash: '#242423',
        violet: '#b23386',
        red: '#dc341e',
        //Service
        'light-grey-e9': '#e9e9e9',
        'light-grey-dd': '#dddddd',
        'dark-grey-33': '#333333',
        'dark-grey-28': '#282828'
      },
      screens: {
        sm: '640px',
        md: '768px',
        lg: '1024px',
        xl: '1280px',
        '2xl': '1536px'
      }
    }
  },
  plugins: [require('@tailwindcss/forms'), require('@tailwindcss/typography')],
  safelist: [
    {
      pattern:
        /(bg|text|border)-(black|white|transparent|pink|yellow|dark-yellow|teal|purple|brown|orange|grey|red|cream|green|violet|blue|dark-orange|dark-grey-33|dark-grey-28|light-grey-e9|light-grey-dd)/
    },
    {
      pattern: /(mt|mb|mr|ml|my|mx|px|py|pt|pb|pl|pr)-[0-9]+/
    },
    {
      pattern: /flex-.*/
    },
    {
      pattern: /(bottom|right|top|left)-[0-9]+/
    },
    {
      pattern: /(w|h)-[0-9]+/
    }
  ]
}
