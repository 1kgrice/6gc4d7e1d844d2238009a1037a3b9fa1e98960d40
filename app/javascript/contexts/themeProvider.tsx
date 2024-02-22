import React, { createContext, useState, useContext, useEffect } from 'react'

const ThemeContext = createContext({ colorTheme: 'light', setColorTheme: (theme) => {} })

export const useTheme = () => useContext(ThemeContext)
export const ThemeProvider = ({ children }) => {
  const [colorTheme, setColorTheme] = useState('light') // default mode

  useEffect(() => {
    const matchDarkMode = window.matchMedia('(prefers-color-scheme: dark)')
    const handleThemeChange = (event) => {
      setColorTheme(event.matches ? 'dark' : 'light')
    }

    matchDarkMode.addEventListener('change', handleThemeChange)
    setColorTheme(matchDarkMode.matches ? 'dark' : 'light')

    return () => {
      matchDarkMode.removeEventListener('change', handleThemeChange)
    }
  }, [])

  return (
    <ThemeContext.Provider value={{ colorTheme, setColorTheme }}>{children}</ThemeContext.Provider>
  )
}
