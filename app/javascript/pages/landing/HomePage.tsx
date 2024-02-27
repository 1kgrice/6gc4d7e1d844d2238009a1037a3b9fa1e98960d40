import React, { Fragment } from 'react'
import { Footer, LogoBanner, GridSection, GridSectionButton, GridHalves } from '~/components'
import { boardMeeting } from '~/assets/images'
import { routes as routesDiscover } from '~/routes/discover'

export default function HomePage() {
  const content = {
    sectionLeft: {
      header: 'Hi there!',
      introMessage: (
        <Fragment>
          This website was created to get familiar with the Gumroad platform and its creators. It's
          a replica of the Discover module with a few minor differences. All items listed here are
          real Gumroad products. Have a look around.
        </Fragment>
      ),
      button: {
        label: 'Show me',
        href: routesDiscover.homeAbsolute || ''
      }
    },
    sectionRight: {
      image: {
        src: boardMeeting,
        alt: 'The Meeting',
        className: 'hover:border-4 hover:border-white transition ease-in-out duration-300',
        description: (
          <div className="text-md">
            <p className="pb-2 block text-white">
              <b>&quot;The Meeting&quot;</b>, mixed media, 2024
            </p>
          </div>
        )
      }
    },
    footerMessage: (
      <Fragment>
        A creator has no goal, only a path.
        <br />
      </Fragment>
    )
  }

  return (
    <>
      <LogoBanner />
      <GridHalves>
        <GridSection
          variant="text"
          className="bg-pink border-black border-r-4 text-sm border-b-2 lg:border-b-0"
          textHeader={content.sectionLeft.header}
          textContent={content.sectionLeft.introMessage}
          button={
            <GridSectionButton
              {...content.sectionLeft.button}
              className="border-2 border-black hover:bg-dark-yellow hover:text-black transition ease-in-out duration-300"
            />
          }
        ></GridSection>
        <GridSection
          variant="image"
          className="bg-ash"
          imgProps={content.sectionRight.image}
        ></GridSection>
      </GridHalves>
      <Footer message={content.footerMessage} standardColor />
    </>
  )
}
