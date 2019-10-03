module.exports = {
  theme: {
    extend: {
      colors: {
        //Accent Colors
        "dark-blue": "#363687",

        info: {
          blue: "#376fdd",
          "blue-lighten-85": "rgba(55, 111, 221, 0.15)",
          "blue-lighten-90": "rgba(55, 111, 221, 0.1)",
          "blue-lighten-95": "rgba(55, 111, 221, 0.05)"
        },

        // Background Colors
        sand: "#f4f1e6",
        "sand-lighten-20": "rgba(249, 246, 243, 0.8)",

        // Primary Color
        primary: {
          default: "#f9543e",
          "dark-10": "#df4b37",
          "dark-5": "#ec4f3a",
          "lighten-90": "rgb(249, 84, 62, 0.1)",
          "lighten-50": "rgb(249, 84, 62, 0.5)"
        },
        
        main: {
          // Text Colors
          black: "#23242e",
          "lighten-10": "rgba(35, 36, 46, 0.90)",
          "lighten-15": "rgba(35,36,46,.85)",
          "lighten-20": "rgba(35, 36, 46, 0.80)",
          "lighten-50": "rgba(35, 36, 46, 0.5)",
          "lighten-65": "rgba(35, 36, 46, 0.35)",
          "lighten-90": "rgba(35, 36, 46, 0.1)",
          "lighten-95": "rgba(35, 36, 46, 0.05)"
        },

        bs: {
          purple: "rgb(171, 94, 163)"
        },
        "white-80": "rgba(255,255,255,0.8)",
      }
    },
    screens: {
      'sm': '576px',
      'md': '768px',
      'lg': '992px',
      'xl': '1200px',
    },
    /* Most of the time we customize the font-sizes,
     so we added the Tailwind default values here for
     convenience */
    fontSize: {
      'xs': '.75rem',     // 12px
      'sm': '.875rem',    // 14px
      'base': '1rem',     // 16px
      'lg': '1.125rem',   // 18px
      'xl': '1.25rem',    // 20px
      '2xl': '1.5rem',    // 24px
      '3xl': '2rem',      // 32px
      '4xl': '2.125rem',  // 34px
      '5xl': '2.25rem',   // 36px
      '6xl': '2.625rem',  // 42px
    },
    fontWeight: {
      'hairline': 100,
      'thin': 200,
      'light': 300,
      'normal': 400,
      'medium': 500,
      'semibold': 600,
      'bold': 700,
      'extrabold': 800,
      'black': 900,
    },
    lineHeight: {
      'none': 1,
      'tight': 1.25,
      'normal': 1.875,
      'loose': 2,
      '1': 1.25,
      '2': 1.3,
      '3': 1.4,
      '4': 1.5,
      '5': 1.75
    },
    letterSpacing: {
      'tight': '-0.05em',
      'normal': '0',
      'wide': '0.075em',
    },
    maxWidth: {
      'xs': '20rem',    //  320px
      'sm': '30rem',    //  480px
      'md': '40rem',    //  640px
      'lg': '50rem',    //  800px
      'xl': '60rem',    //  960px
      '2xl': '70rem',   // 1120px
      '3xl': '80rem',   // 1280px 
      '4xl': '90rem',   // 1440px
      '5xl': '100rem',  // 1600px
      'full': '100%',
    },
    /* We override the default font-families with our own default prefs  */
    fontFamily: {
      montserrat: [
        "Montserrat",
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Arial",
        "sans-serif"
      ],
      overpass: [
        "Overpass",
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Arial",
        "sans-serif"
      ],
      mono: [
        "Roboto Mono",
        "SFMono-Regular",
        "Segoe UI",
        "Courier",
        "monospace"
      ]
    }
  },
  variants: {
    color: ["hover"],
    cursor: ["hover"],
    width: ["responsive"],
    border: ["hover"]
  },
  plugins: []
};
