import React, { useEffect, useState } from 'react'
import {
  CRow,
  CCol,
  CCard,
  CCardHeader,
  CCardBody,
  CTable,
  CTableHead,
  CTableRow,
  CTableHeaderCell,
  CTableBody,
  CTableDataCell,
  CButton,
} from '@coreui/react'
import { db } from '../../firebaseConfig/firebase'
import { collection, getDocs, deleteDoc, doc } from 'firebase/firestore'

const ViewCategory = () => {
  const [categories, setCategories] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  const fetchCategories = async () => {
    try {
      const categorySnapshot = await getDocs(collection(db, 'categories'))
      const categoryList = categorySnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }))
      setCategories(categoryList)
    } catch (err) {
      console.error('Error fetching categories:', err)
      setError('Failed to load categories.')
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async (categoryId) => {
    const confirmDelete = window.confirm("Are you sure you want to delete this category?");
    if (!confirmDelete) return;

    try {
      await deleteDoc(doc(db, 'categories', categoryId))
      setCategories(categories.filter(category => category.id !== categoryId))
    } catch (err) {
      console.error('Error deleting category:', err)
      alert('Failed to delete category.')
    }
  }

  useEffect(() => {
    fetchCategories()
  }, [])

  if (loading) {
    return <p>Loading categories...</p>
  }

  if (error) {
    return <p className="text-danger">{error}</p>
  }

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>Category List</strong>
          </CCardHeader>
          <CCardBody>
            <CTable>
              <CTableHead>
                <CTableRow>
                  <CTableHeaderCell>#</CTableHeaderCell>
                  <CTableHeaderCell>Category Name</CTableHeaderCell>
                  <CTableHeaderCell>Description</CTableHeaderCell>
                  <CTableHeaderCell>Image</CTableHeaderCell>
                  <CTableHeaderCell>Actions</CTableHeaderCell>
                </CTableRow>
              </CTableHead>
              <CTableBody>
                {categories.map((category, index) => (
                  <CTableRow key={category.id}>
                    <CTableHeaderCell>{index + 1}</CTableHeaderCell>
                    <CTableDataCell>{category.categoryName}</CTableDataCell>
                    <CTableDataCell>{category.categoryDescription}</CTableDataCell>
                    <CTableDataCell>
                      {category.categoryImage ? (
                        <img
                          src={category.categoryImage}
                          alt="Category"
                          style={{ width: '50px' }}
                        />
                      ) : (
                        <p>No Image</p>
                      )}
                    </CTableDataCell>
                    <CTableDataCell>
                      <CButton color="danger" size="sm" onClick={() => handleDelete(category.id)}>
                        Delete
                      </CButton>
                    </CTableDataCell>
                  </CTableRow>
                ))}
              </CTableBody>
            </CTable>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}

export default ViewCategory
