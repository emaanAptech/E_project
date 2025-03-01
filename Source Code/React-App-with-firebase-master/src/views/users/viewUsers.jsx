import React, { useState, useEffect } from 'react'
import {
  CButton,
  CCard,
  CCardBody,
  CCardHeader,
  CCol,
  CRow,
  CTable,
  CTableBody,
  CTableDataCell,
  CTableHead,
  CTableHeaderCell,
  CTableRow,
  CModal,
  CModalBody,
  CModalHeader,
  CModalFooter,
  CForm,
  CFormInput,
  CFormLabel,
} from '@coreui/react'
import { db } from '../../firebaseConfig/firebase'
import { collection, getDocs, doc, getDoc, deleteDoc, updateDoc } from 'firebase/firestore'

const ViewUsers = () => {
  const [users, setUsers] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [editModalVisible, setEditModalVisible] = useState(false)
  const [selectedUser, setSelectedUser] = useState(null)
  const [editedData, setEditedData] = useState({ userName: '', userEmail: '', roleName: '' })

  useEffect(() => {
    const fetchUsers = async () => {
      setLoading(true)
      setError(null)
      try {
        const usersCollection = collection(db, 'users')
        const userSnapshot = await getDocs(usersCollection)
  
        const userData = await Promise.all(
          userSnapshot.docs.map(async (userDoc) => {
            const user = userDoc.data()
            const roleRef = user.roleRef
  
            if (!roleRef) {
              console.warn(`Missing roleRef for user: ${user.userName}`)
              return { id: userDoc.id, ...user, roleName: 'Unknown' }
            }
  
            try {
              const roleReference = typeof roleRef === 'string' ? doc(db, roleRef) : roleRef
              const roleDoc = await getDoc(roleReference)
              const roleName = roleDoc.exists() ? roleDoc.data().roleName : 'Unknown'
              return { id: userDoc.id, ...user, roleName }
            } catch (err) {
              console.error(`Error fetching role for ${user.userName}:`, err)
              return { id: userDoc.id, ...user, roleName: 'Unknown' }
            }
          })
        )
  
        setUsers(userData)
      } catch (err) {
        console.error('Error fetching users:', err)
        setError('Failed to fetch users.')
      } finally {
        setLoading(false)
      }
    }
  
    fetchUsers()
  }, [])

  // Handle delete functionality
  const handleDelete = async (id) => {
    try {
      await deleteDoc(doc(db, 'users', id))
      setUsers((prevUsers) => prevUsers.filter((user) => user.id !== id))
    } catch (err) {
      console.error('Error deleting user:', err)
      alert('Failed to delete user.')
    }
  }

  // Handle edit button click
  const handleEdit = (id) => {
    const user = users.find((user) => user.id === id)
    setSelectedUser(user)
    setEditedData({ userName: user.userName, userEmail: user.userEmail, roleName: user.roleName })
    setEditModalVisible(true)
  }

  // Handle form input changes
  const handleInputChange = (e) => {
    const { name, value } = e.target
    setEditedData((prevData) => ({ ...prevData, [name]: value }))
  }

  // Handle form submission
  const handleSave = async () => {
    if (!selectedUser) return
    try {
      const userDocRef = doc(db, 'users', selectedUser.id)
      await updateDoc(userDocRef, {
        userName: editedData.userName,
        userEmail: editedData.userEmail,
        // Handle role update if necessary
      })
      setUsers((prevUsers) =>
        prevUsers.map((user) =>
          user.id === selectedUser.id
            ? { ...user, userName: editedData.userName, userEmail: editedData.userEmail }
            : user
        )
      )
      setEditModalVisible(false)
      alert('User updated successfully!')
    } catch (err) {
      console.error('Error updating user:', err)
      alert('Failed to update user.')
    }
  }

  return (
    <CRow>
      <CCol xs={12}>
        <CCard>
          <CCardHeader>
            <strong>View Users</strong>
          </CCardHeader>
          <CCardBody>
            {loading ? (
              <p>Loading users...</p>
            ) : error ? (
              <p className="text-danger">{error}</p>
            ) : (
              <CTable bordered hover>
                <CTableHead>
                  <CTableRow>
                    <CTableHeaderCell>#</CTableHeaderCell>
                    <CTableHeaderCell>Name</CTableHeaderCell>
                    <CTableHeaderCell>Email</CTableHeaderCell>
                    <CTableHeaderCell>Role</CTableHeaderCell>
                    <CTableHeaderCell>Actions</CTableHeaderCell>
                  </CTableRow>
                </CTableHead>
                <CTableBody>
                  {users.map((user, index) => (
                    <CTableRow key={user.id}>
                      <CTableDataCell>{index + 1}</CTableDataCell>
                      <CTableDataCell>{user.userName}</CTableDataCell>
                      <CTableDataCell>{user.userEmail}</CTableDataCell>
                      <CTableDataCell>{user.roleName}</CTableDataCell>
                      <CTableDataCell>
                        <CButton
                          color="warning"
                          size="sm"
                          className="me-2"
                          onClick={() => handleEdit(user.id)}
                        >
                          Edit
                        </CButton>
                        <CButton
                          color="danger"
                          size="sm"
                          onClick={() => handleDelete(user.id)}
                        >
                          Delete
                        </CButton>
                      </CTableDataCell>
                    </CTableRow>
                  ))}
                </CTableBody>
              </CTable>
            )}
          </CCardBody>
        </CCard>
      </CCol>

      {/* Edit Modal */}
      <CModal visible={editModalVisible} onClose={() => setEditModalVisible(false)}>
        <CModalHeader>Edit User</CModalHeader>
        <CModalBody>
          <CForm>
            <CFormLabel>Name</CFormLabel>
            <CFormInput
              name="userName"
              value={editedData.userName}
              onChange={handleInputChange}
            />
            <CFormLabel>Email</CFormLabel>
            <CFormInput
              name="userEmail"
              value={editedData.userEmail}
              onChange={handleInputChange}
            />
          </CForm>
        </CModalBody>
        <CModalFooter>
          <CButton color="primary" onClick={handleSave}>
            Save
          </CButton>
          <CButton color="secondary" onClick={() => setEditModalVisible(false)}>
            Cancel
          </CButton>
        </CModalFooter>
      </CModal>
    </CRow>
  )
}

export default ViewUsers
