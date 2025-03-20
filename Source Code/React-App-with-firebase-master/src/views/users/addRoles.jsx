import React, { useState, useEffect } from 'react';
import {
  CButton,
  CCard,
  CCardBody,
  CCardHeader,
  CCol,
  CForm,
  CFormSelect,
  CFormLabel,
  CRow,
  CListGroup,
  CListGroupItem,
} from '@coreui/react';
import { db } from '../../firebaseConfig/firebase';
import { collection, addDoc, getDocs, deleteDoc, doc } from 'firebase/firestore';

const AddUserRoles = () => {
  const [roleName, setRoleName] = useState('Admin'); // Default role
  const [roles, setRoles] = useState([]);

  // Handle dropdown selection
  const handleInputChange = (e) => {
    setRoleName(e.target.value);
  };

  // Add role to Firestore
  const handleAddRole = async (e) => {
    e.preventDefault();
    if (roleName.trim()) {
      try {
        const docRef = await addDoc(collection(db, 'userRoles'), {
          roleName: roleName,
        });
        setRoles([...roles, { id: docRef.id, roleName }]); // Update local state
      } catch (error) {
        console.error('Error adding role: ', error);
      }
    }
  };

  // Fetch roles from Firestore
  const fetchRoles = async () => {
    try {
      const querySnapshot = await getDocs(collection(db, 'userRoles'));
      const fetchedRoles = querySnapshot.docs.map((doc) => ({
        id: doc.id,
        roleName: doc.data().roleName,
      }));
      setRoles(fetchedRoles);
    } catch (error) {
      console.error('Error fetching roles: ', error);
    }
  };

  // Delete role from Firestore
  const handleDeleteRole = async (index) => {
    const roleToDelete = roles[index];
    if (!roleToDelete.id) {
      console.error('Invalid document ID');
      return;
    }
    try {
      await deleteDoc(doc(db, 'userRoles', roleToDelete.id));
      fetchRoles(); // Refresh roles after deletion
    } catch (error) {
      console.error('Error deleting role: ', error);
    }
  };

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
                <CFormLabel htmlFor="roleDropdown">Select Role</CFormLabel>
                <CFormSelect id="roleDropdown" value={roleName} onChange={handleInputChange}>
                  <option value="Admin">Admin</option>
                  <option value="User">User</option>
                </CFormSelect>
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
                  <CListGroupItem key={role.id} className="d-flex justify-content-between align-items-center">
                    {role.roleName}
                    <CButton color="danger" size="sm" onClick={() => handleDeleteRole(index)}>
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
  );
};

export default AddUserRoles;
