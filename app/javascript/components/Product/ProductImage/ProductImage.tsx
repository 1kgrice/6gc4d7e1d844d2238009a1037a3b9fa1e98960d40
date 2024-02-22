import React, { Fragment, useMemo, useState } from 'react'
import Skeleton from 'react-loading-skeleton'
import { SkeletonContainer } from '~/components'
import resolveConfig from 'tailwindcss/resolveConfig'
import tailwindConfig from '~/../../tailwind.config.js'
import { useTheme } from '~/contexts/themeProvider'
import { Img } from 'react-image'

interface ProductImageProps {
  src: string | string[]
  alt?: string
  width?: number | string
  height?: number | string
  loading?: 'lazy' | 'eager'
}

const ProductImage: React.FC<ProductImageProps> = ({ src, alt, width, height, loading }) => {
  // const twConfig = resolveConfig(tailwindConfig)
  // const { colorTheme } = useTheme()
  // const { baseColor, highlightColor } = useMemo(() => {
  //   const themeColors = twConfig.theme.colors
  //   return {
  //     baseColor: themeColors[colorTheme === 'light' ? 'light-grey-dd' : 'dark-grey-33'],
  //     highlightColor: themeColors[colorTheme === 'light' ? 'light-grey-e9' : 'dark-grey-28']
  //   }
  // }, [colorTheme])

  return (
    <Fragment>
      <Img
        loading={loading || 'lazy'}
        src={src}
        alt={alt}
        loader={
          <SkeletonContainer>
            <Skeleton width={width} height={height} />
          </SkeletonContainer>
        }
      />
    </Fragment>
  )
}

export default ProductImage
