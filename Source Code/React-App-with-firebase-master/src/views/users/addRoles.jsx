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
  CRow,
  CListGroup,
  CListGroupItem,
} from '@coreui/react';
import {db} from '../../firebaseConfig/firebase';
import { getFirestore, collection, addDoc, getDocs, deleteDoc, doc } from 'firebase/firestore';


const AddUserRoles = () => {
  const [roleName, setRoleName] = useState('')
  const [roles, setRoles] = useState([]) // Roles list

  const handleInputChange = (e) => {
    setRoleName(e.target.value)
  }

   // Add role to Firestore
   const handleAddRole = async (e) => {
    e.preventDefault();
    if (roleName.trim()) {
      try {
        // Add role to Firestore
        await addDoc(collection(db, 'userRoles'), {
          roleName: roleName,
        });
        setRoles([...roles, roleName]); // Update the local state with the new role
        setRoleName(''); // Clear the input field
      } catch (error) {
        console.error('Error adding role: ', error);
      }
    }
  };

  // Fetch roles from Firestore (to display the existing roles)
  const fetchRoles = async () => {
    try {
      const querySnapshot = await getDocs(collection(db, 'userRoles'));
      const fetchedRoles = [];
      querySnapshot.forEach((doc) => {
        fetchedRoles.push(doc.data().roleName);
      });
      setRoles(fetchedRoles);
    } catch (error) {
      console.error('Error fetching roles: ', error);
    }
  };

  const handleDeleteRole = async (index) => {
    const roleToDelete = roles[index];  // Get the role to delete
    console.log('Role to delete: ', roleToDelete);  // Debugging role to delete
  
    // Firestore Document Reference (Assuming roles are stored in a 'roles' collection)
    const roleDocRef = doc(db, 'roles', roleToDelete);  // 'roles' is the collection, roleToDelete is the document ID
    console.log('Document Reference:', roleDocRef);  // Debugging document reference
  
    try {
      // Delete role from Firestore
      await deleteDoc(roleDocRef);
      console.log('Role deleted successfully from Firestore');
  
      // Remove role from state
      const updatedRoles = roles.filter((_, i) => i !== index);
      setRoles(updatedRoles);
    } catch (error) {
      console.error('Error deleting role: ', error);
    }
  };

  // Fetch the roles when the component mounts
  useEffect(() => {
    fetchRoles();
  }, []);

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>Add User Roles</strong>
          </CCardHeader>
          <CCardBody>
            <CForm onSubmit={handleAddRole}>
              <div className="mb-3">
                <CFormLabel htmlFor="roleName">Role Name</CFormLabel>
                <CFormInput
                  type="text"
                  id="roleName"
                  placeholder="Enter role name"
                  value={roleName}
                  onChange={handleInputChange}
                  required
                />
              </div>
              <CButton type="submit" color="primary">
                Add Role
              </CButton>
            </CForm>
            <hr />
            <h5 className="mt-4">Existing Roles</h5>
            {roles.length === 0 ? (
              <p>No roles added yet.</p>
            ) : (
              <CListGroup>
                {roles.map((role, index) => (
                  <CListGroupItem key={index} className="d-flex justify-content-between align-items-center">
                    {role}
                    <CButton
                      color="danger"
                      size="sm"
                      onClick={() => handleDeleteRole(index)}
                    >
                      Delete
                    </CButton>
                  </CListGroupItem>
                ))}
              </CListGroup>
            )}
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}

export default AddUserRoles
