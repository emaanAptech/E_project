import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { CButton, CForm, CFormInput, CInputGroup, CInputGroupText, CRow, CCol } from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilLockLocked, cilUser } from '@coreui/icons'

const Login = () => {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const navigate = useNavigate()

  const handleLogin = () => {
    const hardcodedUsername = 'admin'
    const hardcodedPassword = 'password123'

    if (username === hardcodedUsername && password === hardcodedPassword) {
      localStorage.setItem('isLoggedIn', true)
      navigate('/dashboard') // Redirect to the dashboard or default page
    } else {
      setError('Invalid username or password')
    }
  }

  return (
    <div className="bg-body-tertiary min-vh-100 d-flex flex-row align-items-center">
      <div className="container">
        <CRow className="justify-content-center">
          <CCol md={6}>
            <CForm>
              <h1>Login</h1>
              <p className="text-medium-emphasis">Sign in to your account</p>
              {error && <p style={{ color: 'red' }}>{error}</p>}
              <CInputGroup className="mb-3">
                <CInputGroupText>
                  <CIcon icon={cilUser} />
                </CInputGroupText>
                <CFormInput
                  placeholder="Username"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                />
              </CInputGroup>
              <CInputGroup className="mb-4">
                <CInputGroupText>
                  <CIcon icon={cilLockLocked} />
                </CInputGroupText>
                <CFormInput
                  type="password"
                  placeholder="Password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                />
              </CInputGroup>
              <CRow>
                <CCol xs={6}>
                  <CButton color="primary" className="px-4" onClick={handleLogin}>
                    Login
                  </CButton>
                </CCol>
              </CRow>
            </CForm>
          </CCol>
        </CRow>
      </div>
    </div>
  )
}

export default Login