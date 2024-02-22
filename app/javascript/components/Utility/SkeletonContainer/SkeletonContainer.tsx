import React, { useMemo, PropsWithChildren } from 'react'
import Skeleton, { SkeletonTheme } from 'react-loading-skeleton'
import resolveConfig from 'tailwindcss/resolveConfig'
import tailwindConfig from '~/../../tailwind.config.js'
import { useTheme } from '~/contexts/themeProvider'
const twConfig = resolveConfig(tailwindConfig)

interface ISkeletonContainer {
  className?: string
}

const SkeletonContainer = (props: PropsWithChildren<ISkeletonContainer>) => {
  const { colorTheme } = useTheme()

  const { baseColor, highlightColor } = useMemo(() => {
    const themeColors = twConfig.theme.colors
    return {
      baseColor: themeColors[colorTheme === 'light' ? 'light-grey-dd' : 'dark-grey-33'],
      highlightColor: themeColors[colorTheme === 'light' ? 'light-grey-e9' : 'dark-grey-28']
    }
  }, [colorTheme])

  return (
    <div className={props.className}>
      <SkeletonTheme baseColor={baseColor} highlightColor={highlightColor}>
        {props.children}
      </SkeletonTheme>
    </div>
  )
}

export default SkeletonContainer
