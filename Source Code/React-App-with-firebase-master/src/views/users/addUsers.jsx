import React, { useState, useEffect } from 'react'
import {
  CButton,
  CCard,
  CCardBody,
  CCardHeader,
  CCol,
  CForm,
  CFormInput,
  CFormLabel,
  CFormSelect,
  CRow,
} from '@coreui/react'
import {db} from '../../firebaseConfig/firebase';
import { collection, getDocs, addDoc, query, where,  } from 'firebase/firestore' // Firestore methods

const AddUsers = () => {
  const [formData, setFormData] = useState({
    userName: '',
    userEmail: '',
    userPassword: '',
    userRole: '',
  })
  const [roles, setRoles] = useState([]) // For storing roles
  const [loading, setLoading] = useState(false) // For loading state
  const [error, setError] = useState(null) // For error state

  // Fetch roles from Firestore
  useEffect(() => {
    const fetchRoles = async () => {
      setLoading(true)
      setError(null)
      try {
        const rolesCollection = collection(db, 'userRoles') // Reference to the 'roles' collection
        const rolesSnapshot = await getDocs(rolesCollection)
        const rolesData = rolesSnapshot.docs.map((doc) => doc.data().roleName) // Assuming each document has a 'name' field
        setRoles(rolesData)
        // console.log('Roles:', rolesData)
      } catch (err) {
        console.error('Error fetching roles:', err)
        setError('Failed to fetch roles.')
      } finally {
        setLoading(false)
      }
    }

    fetchRoles()
  }, [])

  // Handle input change
  const handleInputChange = (e) => {
    const { id, value } = e.target
    setFormData({ ...formData, [id]: value })
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log('User Data Submitted:', formData);
  
    try {
      // Get the reference to the roles collection
      const rolesCollection = collection(db, 'userRoles');
  
      // Find the role document with the selected roleName
      const roleQuery = query(rolesCollection, where('roleName', '==', formData.userRole));
      const roleSnapshot = await getDocs(roleQuery);
  
      if (roleSnapshot.empty) {
        console.error('Role not found in Firestore.');
        return;
      }
  
      // Assuming there’s only one role document with the given roleName
      const roleDocRef = roleSnapshot.docs[0].ref;
  
      // Add user data to Firestore, including the role reference
      const usersCollection = collection(db, 'users'); // Reference to your users collection
      await addDoc(usersCollection, {
        userName: formData.userName,
        userEmail: formData.userEmail,
        userPassword: formData.userPassword,
        roleRef: roleDocRef, // Storing the reference to the role document
      });
  
      console.log('User added successfully!');
      // Reset form after submission
      setFormData({
        userName: '',
        userEmail: '',
        userPassword: '',
        userRole: '',
      });
    } catch (error) {
      console.error('Error adding user:', error);
    }
  };

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>Add Users</strong>
          </CCardHeader>
          <CCardBody>
            <CForm onSubmit={handleSubmit}>
              <div className="mb-3">
                <CFormLabel htmlFor="userName">User Name</CFormLabel>
                <CFormInput
                  type="text"
                  id="userName"
                  placeholder="Enter user name"
                  value={formData.userName}
                  onChange={handleInputChange}
                  required
                />
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="userEmail">Email</CFormLabel>
                <CFormInput
                  type="email"
                  id="userEmail"
                  placeholder="Enter email address"
                  value={formData.userEmail}
                  onChange={handleInputChange}
                  required
                />
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="userPassword">Password</CFormLabel>
                <CFormInput
                  type="password"
                  id="userPassword"
                  placeholder="Enter password"
                  value={formData.userPassword}
                  onChange={handleInputChange}
                  required
                />
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="userRole">Role</CFormLabel>
                {loading ? (
                  <p>Loading roles...</p>
                ) : error ? (
                  <p className="text-danger">{error}</p>
                ) : (
                  <CFormSelect
                    id="userRole"
                    value={formData.userRole}
                    onChange={handleInputChange}
                    required
                  >
                    <option value="">Select a role</option>
                    {roles.map((role, index) => (
                      <option key={index} value={role}>
                        {role}
                      </option>
                    ))}
                  </CFormSelect>
                )}
              </div>
              <CButton type="submit" color="primary" disabled={loading}>
                Add User
              </CButton>
            </CForm>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}

export default AddUsers
