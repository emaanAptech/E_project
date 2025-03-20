import React, { useState, useEffect } from 'react';
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
} from '@coreui/react';
import { db } from '../../firebaseConfig/firebase';
import { collection, getDocs, deleteDoc, doc } from 'firebase/firestore';

const ViewRoles = () => {
  const [roles, setRoles] = useState([]);

  // Fetch roles from Firestore
  const fetchRoles = async () => {
    try {
      const querySnapshot = await getDocs(collection(db, 'userRoles'));
      const fetchedRoles = querySnapshot.docs.map((doc) => ({
        id: doc.id,
        name: doc.data().roleName, // Firestore field
      }));
      setRoles(fetchedRoles);
    } catch (error) {
      console.error('Error fetching roles: ', error);
    }
  };

  // Delete role from Firestore
  const handleDelete = async (roleId) => {
    try {
      await deleteDoc(doc(db, 'userRoles', roleId));
      setRoles(roles.filter((role) => role.id !== roleId)); // Update state after deletion
    } catch (error) {
      console.error('Error deleting role: ', error);
    }
  };

  const handleEdit = (id) => {
    alert(`Edit functionality for role with ID: ${id}`);
    // Add your edit logic here
  };

  useEffect(() => {
    fetchRoles();
  }, []);

  return (
    <CRow>
      <CCol xs={12}>
        <CCard>
          <CCardHeader>
            <strong>View Roles</strong>
          </CCardHeader>
          <CCardBody>
            <CTable bordered hover>
              <CTableHead>
                <CTableRow>
                  <CTableHeaderCell>#</CTableHeaderCell>
                  <CTableHeaderCell>Role Name</CTableHeaderCell>
                  <CTableHeaderCell>Actions</CTableHeaderCell>
                </CTableRow>
              </CTableHead>
              <CTableBody>
                {roles.length === 0 ? (
                  <CTableRow>
                    <CTableDataCell colSpan="3" className="text-center">
                      No roles found.
                    </CTableDataCell>
                  </CTableRow>
                ) : (
                  roles.map((role, index) => (
                    <CTableRow key={role.id}>
                      <CTableDataCell>{index + 1}</CTableDataCell>
                      <CTableDataCell>{role.name}</CTableDataCell>
                      <CTableDataCell>
                        <CButton color="warning" size="sm" className="me-2" onClick={() => handleEdit(role.id)}>
                          Edit
                        </CButton>
                        <CButton color="danger" size="sm" onClick={() => handleDelete(role.id)}>
                          Delete
                        </CButton>
                      </CTableDataCell>
                    </CTableRow>
                  ))
                )}
              </CTableBody>
            </CTable>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  );
};

export default ViewRoles;
