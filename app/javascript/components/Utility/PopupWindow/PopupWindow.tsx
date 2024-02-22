import React from 'react'

const PopupWindow = ({ isOpen, onClose, title, message, children }) => {
  if (!isOpen) return null

  return (
    <div className="fixed inset-0 z-50 bg-black bg-opacity-50 flex justify-center items-center p-4">
      <div className="bg-white rounded-lg shadow-lg overflow-hidden max-w-lg w-full">
        <div className="relative">
          {/* <span
            onClick={onClose}
            className="m-1 icon icon-solid-x cursor-pointer absolute top-2 right-2 text-gray-600 hover:text-gray-900"
            aria-label="Close"
          ></span> */}
          <div className="p-8">
            {title && <h1 className="text-xl font-semibold mb-2">{title}</h1>}
            {message && <p className="text-lg">{message}</p>}
            {children}
          </div>
        </div>
      </div>
    </div>
  )
}

export default PopupWindow
