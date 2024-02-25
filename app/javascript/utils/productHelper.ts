import { Product } from '~/models'

export const getButtonText = (product: Product | undefined) => {
  if (!product) return 'Add to cart'
  const optionMap: { [key: string]: string } = {
    i_want_this_prompt: 'I want this!',
    buy_this_prompt: 'Buy this',
    pay_prompt: 'Pay'
  }

  return (
    product.customViewContentButtonText ||
    optionMap[product.customButtonTextOption] ||
    'Add to cart'
  )
}