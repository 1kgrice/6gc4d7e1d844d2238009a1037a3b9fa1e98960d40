import { useState, useEffect } from 'react';
import resolveConfig from 'tailwindcss/resolveConfig'
import tailwindConfig from '~/../../tailwind.config.js'
const twConfig = resolveConfig(tailwindConfig)

export const useViewportIsAbove = (value: 'sm' | 'md' | 'lg' | 'xl' | '2xl') => {
  const breakpoint = parseInt(twConfig.theme.screens[value].replace('px', ''), 10);
  const [isAbove, setIsAbove] = useState(() => window.innerWidth > breakpoint);

  useEffect(() => {
    const handleResize = () => {
      setIsAbove(window.innerWidth > breakpoint);
    };

    // Optimize performance by only adding the event listener once
    window.addEventListener('resize', handleResize);
    // Immediately check if the viewport matches the condition on mount
    handleResize();

    // Cleanup function to remove event listener
    return () => window.removeEventListener('resize', handleResize);
  }, [breakpoint]); // Only re-run the effect if the breakpoint changes

  return isAbove;
};
