import React, { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { Category } from '~/models'
import * as api from '~/network/api'
import { ensureLeadingSlash } from '~/utils/urlHelper'

const FilterCategory = () => {
  const [currentCategory, setCurrentCategory] = useState<Category | null>(null)
  const [rootCategories, setRootCategories] = useState<Category[]>([])
  const [parentCategory, setParentCategory] = useState<Category | null>(null)
  const navigate = useNavigate()
  const { category, '*': wildcard } = useParams<{ category?: string; '*': string }>()

  useEffect(() => {
    // Fetch root categories only if not already fetched
    if (rootCategories.length === 0) {
      const fetchRootCategories = async () => {
        try {
          const resp = await api.getRootCategories()
          const newCategories = resp.categories.map((item) => new Category(item))
          setRootCategories(newCategories)
        } catch (error) {
          console.error('Error fetching root categories:', error)
        }
      }

      fetchRootCategories()
    }
  }, [rootCategories]) // Depend on the array itself, but ensure it's only fetched once at component mount

  useEffect(() => {
    const fetchCategoryDetails = async () => {
      const longSlug = wildcard ? `${category}/${wildcard}` : category
      if (!longSlug) {
        // Ensures the component re-renders when currentCategory is empty
        setCurrentCategory(null)
        setParentCategory(null)
        return
      }

      try {
        const { category: fetchedCategory } = await api.getCategoryByLongSlug({ longSlug })
        const categoryInstance = new Category(fetchedCategory)
        setCurrentCategory(categoryInstance)

        // Fetch and set the parent category if exists
        const parentSlug = categoryInstance.ancestors?.[0]?.longSlug
        if (parentSlug) {
          const parentResponse = await api.getCategoryByLongSlug({ longSlug: parentSlug })
          setParentCategory(new Category(parentResponse.category))
        } else {
          setParentCategory(null)
        }
      } catch (error) {
        console.error('Error fetching category details:', error)
        setCurrentCategory(null)
        setParentCategory(null)
      }
    }

    fetchCategoryDetails()
  }, [category, wildcard]) // Depend on URL parameters

  const handleNavigation =
    (longSlug: string) => (e: React.MouseEvent<HTMLAnchorElement, MouseEvent>) => {
      e.preventDefault()
      navigate(ensureLeadingSlash(`${longSlug}${window.location.search}`))
    }

  return (
    <div role="navigation" aria-label="Categories">
      <menu>
        {!currentCategory &&
          rootCategories.map((rootCategory) => (
            <li key={rootCategory.slug}>
              <a
                href={ensureLeadingSlash(rootCategory.longSlug)}
                onClick={handleNavigation(rootCategory.longSlug)}
                style={{ textDecoration: 'none' }}
              >
                {rootCategory.name}
                {rootCategory.isNested && (
                  <span className="icon icon-outline-cheveron-right"></span>
                )}
              </a>
            </li>
          ))}
        {currentCategory && (
          <>
            <li>
              <a
                href={
                  currentCategory.isRoot ? '/' : ensureLeadingSlash(parentCategory?.longSlug || '')
                }
                onClick={handleNavigation(
                  currentCategory.isRoot ? '/' : parentCategory?.longSlug || ''
                )}
                style={{ textDecoration: 'none' }}
              >
                <span className="icon icon-outline-cheveron-left"></span>
                {currentCategory.isRoot ? 'All' : `All ${parentCategory?.name}`}
              </a>
            </li>
            <li>
              <a
                href={ensureLeadingSlash(currentCategory.longSlug)}
                onClick={handleNavigation(currentCategory.longSlug)}
                style={{ textDecoration: 'none' }}
              >
                {currentCategory.name}
              </a>
              {currentCategory.children?.length > 0 && (
                <menu>
                  {currentCategory.children.map((subCategory) => (
                    <li key={subCategory.slug}>
                      <a
                        href={ensureLeadingSlash(subCategory.longSlug)}
                        onClick={handleNavigation(subCategory.longSlug)}
                        style={{ textDecoration: 'none' }}
                      >
                        {subCategory.name}
                        {subCategory.isNested && (
                          <span className="icon icon-outline-cheveron-right"></span>
                        )}
                      </a>
                    </li>
                  ))}
                </menu>
              )}
            </li>
          </>
        )}
      </menu>
    </div>
  )
}

export default FilterCategory

// import React, { useCallback, useEffect, useState } from 'react'
// import { useNavigate, useParams } from 'react-router-dom'
// import { Category } from '~/models'
// import * as api from '~/network/api'
// import { ensureLeadingSlash } from '~/utils/urlHelper'

// const FilterCategory: React.FC = () => {
//   const [currentCategory, setCurrentCategory] = useState<Category | null | undefined>()
//   const [rootCategories, setRootCategories] = useState<Category[]>([])
//   const [parentCategory, setParentCategory] = useState<Category | undefined | null>()
//   const navigate = useNavigate()
//   const params = useParams<{ category?: string; '*': string }>()

//   useEffect(() => {
//     const fetchCategoryDetails = async (longSlug: string) => {
//       try {
//         const response = await api.getCategoryByLongSlug({ longSlug })
//         const fetchedCategory = new Category(response.category)
//         setCurrentCategory(fetchedCategory)

//         // Set parent category based on ancestors
//         const parentSlug = fetchedCategory.ancestors?.[0]?.longSlug
//         if (parentSlug) {
//           const parentResponse = await api.getCategoryByLongSlug({ longSlug: parentSlug })
//           setParentCategory(new Category(parentResponse.category))
//         } else {
//           setParentCategory(null)
//         }
//       } catch (error) {
//         console.error('Error fetching category details:', error)
//       }
//     }

//     const longSlug = params['*']
//       ? `${params['category']}/${params['*']}`
//       : params['category'] || currentCategory?.longSlug || ''
//     if (longSlug) {
//       fetchCategoryDetails(longSlug)
//     }
//   }, [params, currentCategory])

//   const fetchRootCategories = async () => {
//     try {
//       const resp = await api.getRootCategories()
//       const newCategories = resp.categories.map((item) => new Category(item))
//       console.log('Got root categories')
//       console.log(newCategories)
//       setRootCategories(newCategories)
//     } catch (error) {
//       console.error('Error fetching categories:', error)
//     }
//   }
//   useEffect(() => {
//     if (!currentCategory) {
//       if (rootCategories.length == 0) fetchRootCategories()
//     }
//   }, [currentCategory])

//   const handleNavigation = useCallback(
//     (longSlug: string, e: React.MouseEvent<HTMLAnchorElement, MouseEvent>) => {
//       e.preventDefault()
//       if (longSlug == '/') {
//         setCurrentCategory(null)
//         setParentCategory(null)
//       }
//       navigate(ensureLeadingSlash(`${longSlug}${window.location.search}`))
//     },
//     [navigate]
//   )

//   return (
//     <div role="navigation" aria-label="Categories">
//       <menu>
//         {!currentCategory &&
//           rootCategories.map((rootCategory) => (
//             <li key={rootCategory.slug}>
//               <a
//                 style={{ textDecoration: 'none' }}
//                 href={ensureLeadingSlash(rootCategory.longSlug)}
//                 onClick={(e) => handleNavigation(rootCategory.longSlug, e)}
//               >
//                 {rootCategory.name}
//                 {rootCategory.isNested && (
//                   <span className="icon icon-outline-cheveron-right"></span>
//                 )}
//               </a>
//             </li>
//           ))}
//         {currentCategory && currentCategory?.isRoot && (
//           <li>
//             <a
//               style={{ textDecoration: 'none' }}
//               href={'/'}
//               onClick={(e) => handleNavigation('/', e)}
//             >
//               <span>
//                 <span className="icon icon-outline-cheveron-left"></span> All
//               </span>
//             </a>
//           </li>
//         )}
//         {currentCategory && parentCategory && (
//           <li>
//             <a
//               style={{ textDecoration: 'none' }}
//               href={ensureLeadingSlash(parentCategory.longSlug)}
//               onClick={(e) => handleNavigation(parentCategory.longSlug, e)}
//             >
//               <span>
//                 <span className="icon icon-outline-cheveron-left"></span> All {parentCategory.name}
//               </span>
//             </a>
//           </li>
//         )}
//         {currentCategory && (
//           <li>
//             <a
//               style={{ textDecoration: 'none' }}
//               href={ensureLeadingSlash(currentCategory.longSlug)}
//               onClick={(e) => handleNavigation(currentCategory.longSlug, e)}
//             >
//               {currentCategory.name}
//             </a>
//             {currentCategory.children && currentCategory.children.length > 0 && (
//               <menu>
//                 {currentCategory.children.map((subCategory) => (
//                   <li key={subCategory.slug}>
//                     <a
//                       style={{ textDecoration: 'none' }}
//                       href={ensureLeadingSlash(subCategory.longSlug)}
//                       onClick={(e) => handleNavigation(subCategory.longSlug, e)}
//                     >
//                       {subCategory.name}
//                       {subCategory.isNested && (
//                         <span className="icon icon-outline-cheveron-right"></span>
//                       )}
//                     </a>
//                   </li>
//                 ))}
//               </menu>
//             )}
//           </li>
//         )}
//       </menu>
//     </div>
//   )
// }

// export default FilterCategory
