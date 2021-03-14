/*
 *
 * Color naming convention:
 *
 * Color with opacity:
 * --------
 * grey-80 => grey with 80% opacity
 *
 * Solid Color:
 * --------
 * grey => grey with RGB value
 *
 * Categorizing colors w/ modifiers:
 * --------
 *
 *  -> If we run out of modifiers, we need to define a new
 *     color name!
 *
 * In case with opacity:
 *
 *
 */
module.exports = {
  purge: {
    // Specify the paths to all of the template files in your project
    content: [
      "src/**/*.res",
      "src/ffi/*.js",
      "./pages/**/*.js",
      "./pages/**/*.mdx",
    ],
    options: {
      whitelist: ["html", "body"]
    }
  },
  theme: {
    extend: {
      colors: {
        gray: {
          "5": "#FAFBFC",
          "10": "#EDF0F2",
          "20": "#CDCDD6",
          "40": "#979AAD",
          "60": "#727489",
          "80": "#3E4057",
          "90": "#010427",
          "95": "#0A0D2F",
          "100": "#010427",
          "5-tr": "rgba(1, 20, 29, 0.02)",
          "10-tr": "rgba(1, 16, 39, 0.05)",
          "20-tr": "rgba(1, 4, 39, 0.2)",
          "40-tr": "rgba(1, 4, 39, 0.4)",
          "60-tr": "rgba(1, 4, 39, 0.6)",
          "80-tr": "rgba(1, 4, 39, 0.8)",
          "95-tr": "rgba(1, 4, 39, 0.95)",
        },
        white: {
          default: "#FFFFFF",
          "80": "rgba(255,255,255,0.8)"
        },
        //primary, secondary:
        fire: {
          default: "#E6484F", //"50"
          "100": "#211332",
          "90": "#790C10",
          "70": "#C3373d",
          "30": "#EDA7AA",
          "10": "#FDE7E8",
        },
        sky: {
          default: "#376FDD", //"50"
          "90": "#0C2E6F",
          "70": "#2258C3",
          "30": "#638FE6",
          "10": "#DDE8FD",
          "5": "#ECF1FC",
        },
        //code-colors start:
        berry: {
          default: "#B151DD",
          "40": "#A766D0",
          "15": "rgba(171, 94, 163, 0.15)"
        },
        water: {
          default: "#5E5EDE",
          dark: "#637CC1",
        },
        turtle: {
          default: "#02A875",
          dark: "#388B72",
        },
        orange: {
          light: "#FFC833",
          default: "#DD8C1B",
          dark: "#D59B74",
          "15": "rgba(224, 172, 0, 0.15)", //old, change
          "10": "rgba(224, 172, 0, 0.10)" //old
        },
      },
      height: {
        "18": "4.5rem" // 72px
      },
      minWidth: {
        "320": "20rem"
      },
      inset: {
        "16": "4rem",
        "18": "4.5rem"
      },
      spacing: {
        "2/3": "66.666667%",
        "9/16": "56.25%",
        "0.75": "0.135rem"
      },
      animation: {
        pulse: 'pulse 0.5s cubic-bezier(0.4, 0, 0.6, 1)',
      },
      keyframes: {
        pulse: {
          '0%, 100%': { opacity: '1' },
          '50%': { opacity: '.5' },
        },
      }
    },
    borderRadius: {
      none: "0",
      sm: ".125rem",
      default: "0.25rem",
      lg: "0.5rem",
      full: "9999px",
      large: "0.75rem"
    },
    screens: {
      xs: "510px",
      sm: "576px",
      md: "768px",
      lg: "1024px",
      xl: "1200px"
    },
    /* Most of the time we customize the font-sizes,
     so we added the Tailwind default values here for
     convenience */
    fontSize: {
      "12": "0.75rem",
      "14": "0.875rem",
      "16": "1rem",
      "18": "1.125rem",
      "21": "1.3125rem",
      "28": "1.5rem",
      "32": "2rem",
      "42": "2.625rem",
      "56": "3.5rem",
      "96": "6rem",
      "smaller-1": "0.9em", // 18px => 16.2px (used for inlineCode)
      sm: ".875rem", // 14px
      base: "1rem", // 16px
      lg: "1.125rem", // 18px
    },
    fontWeight: {
      normal: 400,
      medium: 500,
      semibold: 600,
      bold: 700,
    },
    lineHeight: {
      none: 1,
      tight: 1.25,
      normal: 1.875,
      loose: 2,
      "1": 1.15,
      "2": 1.3,
      "3": 1.4,
      "4": 1.5,
      "5": 1.75
    },
    letterSpacing: {
      tighter: "-0.045em",
      tight: "-0.025em",
      normal: "0",
      wide: "0.075em"
    },
    maxWidth: {
      "320": "20rem",
      "400": "25rem",
      "576": "36rem",
      "1280": "80rem",
      "740": "46.25rem",
      xs: "20rem", //  320px
      sm: "30rem", //  480px
      md: "40rem", //  640px
      lg: "50rem", //  800px
      xl: "67.5rem", // 1080px
      "2xl": "70rem", // 1120px
      "3xl": "80rem", // 1280px
      "4xl": "90rem", // 1440px
      "5xl": "100rem", // 1600px
      none: "none",
      full: "100%"
    },
    /* We override the default font-families with our own default prefs  */
    fontFamily: {
      sans: [
        "Inter",
        "SF Pro Text",
        "Roboto",
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Arial",
        "sans-serif"
      ],
      mono: [
        "SFMono-Regular",
        "Roboto Mono",
        "Menlo",
        "Segoe UI",
        "Courier",
        "monospace"
      ]
    }
  },
  variants: {
    color: ["hover"],
    backgroundColor: ["hover", "active"],
    cursor: ["hover"],
    width: ["responsive"],
    border: ["hover", "responsive"],
    borderWidth: ["active", "responsive", "last", "first"],
    borderRadius: ["first", "responsive"],
    padding: ["hover", "responsive", "last"],
    margin: ["hover", "responsive", "first", "last"],
    visibility: ["group-hover"],
    outline: ["focus"],
  },
  plugins: []
};
