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
 * night
 *  night-lighter -> even lighter version
 *  night-light -> lighter version (obviously)
 *  night -> base color
 *  night-dark -> darker version
 *  night-darker -> even darker version
 *
 *  -> If we run out of modifiers, we need to define a new
 *     color name!
 *
 * In case with opacity:
 * night-80
 *  night-80-lighter
 *  night-80-light
 *  night-80
 *  night-80-dark
 *  night-80-darker
 *
 *
 */
module.exports = {
  purge: {
    // Specify the paths to all of the template files in your project
    content: [
      "./components/**/*.res",
      "./common/**/*.res",
      "./re_pages/**/*.res",
      "./ffi/**/*.js",
      "./pages/**/*.res",
      "./pages/**/*.mdx",
      "./layouts/**/*.res"
    ],
    options: {
      whitelist: ["html", "body"]
    }
  },
  theme: {
    extend: {
      colors: {
        gray: {
          "5": "#F4F4F5",
          "10": "#E5E5E9",
          "20": "#CDCDD6",
          "40": "#979AAD",
          "60": "#727489",
          "80": "#3E4057",
          "95": "#0A0D2F",
          "100": "#010427",
          "5-tr": "rgba(1, 4, 39, 0.05)",
          "10-tr": "rgba(1, 4, 39, 0.1)",
          "20-tr": "rgba(1, 4, 39, 0.2)",
          "40-tr": "rgba(1, 4, 39, 0.4)",
          "60-tr": "rgba(1, 4, 39, 0.6)",
          "80-tr": "rgba(1, 4, 39, 0.8)",
          "95-tr": "rgba(1, 4, 39, 0.95)",
        },
        onyx: {
          default: "#010427",
          "80": "rgba(1, 4, 39, 0.8)",
          "50": "rgba(1, 4, 39, 0.5)"
        },
        night: {
          darker: "#010427",
          dark: "#0A0D2F",
          default: "#3E4057",
          light: "#727489",
          "10": "rgba(62, 64, 87, 0.10)",
          "60": "rgba(62, 64, 87, 0.60)"
        },
        snow: {
          light: "#FAFAFA",
          default: "#F4F4F5",
          dark: "#EAEBED",
          darker: "#BCBEC9"
        },
        white: {
          default: "#FFFFFF",
          "80": "rgba(255,255,255,0.8)"
        },
        fire: {
          default: "#E6484F",
          "80": "rgba(230,72,79, 0.8)",
          "40": "rgba(230,72,79, 0.4)",
          "15": "rgba(230, 72, 79, 0.15)"
        },
        sky: {
          default: "#376FDD",
          "80": "rgba(55, 111, 221, 0.8)",
          "40": "rgba(55, 111, 221, 0.4)",
          "15": "rgba(55, 111, 221, 0.15)",
          "10": "rgba(55, 111, 221, 0.10)"
        },
        berry: {
          default: "#AB5EA3",
          "80": "rgba(171, 94, 163, 0.8)",
          "40": "rgba(171, 94, 163, 0.4)",
          "15": "rgba(171, 94, 163, 0.15)"
        },
        turtle: {
          default: "#38B790"
        },
        gold: {
          light: "#FFC833",
          default: "#E0AC00",
          dark: "#C19400",
          "15": "rgba(224, 172, 0, 0.15)",
          "10": "rgba(224, 172, 0, 0.10)"
        },
        primary: {
          dark: "var(--color-text-primary-dark)",
          default: "var(--color-text-primary)",
          light: "var(--color-text-primary-light)",
          "15": "var(--color-text-primary-15)",
          "40": "var(--color-text-primary-40)",
          "80": "var(--color-text-primary-80)"
        },
        "dark-code": {
          "1": "#DE935F",
          "2": "#81A2BE",
          "3": "#60915F",
          "4": "#999999"
        },
        code: {
          "1": "#DE935F",
          "2": "#81A2BE",
          "3": "#60915F",
          "4": "#999999",
          "5": "#D1BC72"
        },
        "light-grey": "rgba(245, 245, 245, 0.5)",
        "light-grey-20": "rgba(245, 245, 245, 0.2)",
        "ghost-white": "#F8F7F9"
      },
      height: {
        "18": "4.5rem" // 72px
      },
      minWidth: {
        "320": "20rem"
      },
      inset: {
        "18": "4.5rem"
      },
      letterSpacing: {
        tight: "0.02em"
      },
      spacing: {
        "2/3": "66.666667%",
        "9/16": "56.25%"
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
      "14": "0.875rem",
      "16": "1rem",
      "18": "1.125rem",
      "21": "1.3125rem",
      "28": "1.75rem",
      "42": "2.625rem",
      "48": "3rem",
      "smaller-1": "0.9em", // 18px => 16.2px (used for inlineCode)
      xs: ".75rem", // 12px
      sm: ".875rem", // 14px
      base: "1rem", // 16px
      lg: "1.125rem", // 18px
      xl: "1.3125rem", // 21px
      "2xl": "1.5rem", // 24px
      "3xl": "2rem", // 32px
      "4xl": "2.125rem", // 34px
      "5xl": "2.25rem", // 36px
      "6xl": "2.625rem", // 42px
      "7xl": "4.875rem" // 78px
    },
    fontWeight: {
      hairline: 100,
      thin: 200,
      light: 300,
      normal: 400,
      medium: 500,
      semibold: 600,
      bold: 700,
      extrabold: 800,
      black: 900
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
      tight: "-0.03em",
      normal: "0",
      wide: "0.075em"
    },
    maxWidth: {
      "320": "20rem",
      "400": "25rem",
      "1280": "80rem",
      "705": "44.0625rem",
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
        "Menlo",
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
    backgroundColor: ["hover", "active"],
    cursor: ["hover"],
    width: ["responsive"],
    border: ["hover", "responsive"],
    borderWidth: ["active", "responsive", "last", "first"],
    padding: ["hover", "responsive", "last"],
    margin: ["hover", "responsive", "first", "last"],
    visibility: ["group-hover"],
    outline: ["focus"],
  },
  plugins: []
};
