import React from 'react'
import { Navigate } from 'react-router-dom'

const ProtectedRoute = ({ element }) => {
  const isLoggedIn = localStorage.getItem('isLoggedIn')
  return isLoggedIn ? element : <Navigate to="/login" />
}

export default ProtectedRoute
