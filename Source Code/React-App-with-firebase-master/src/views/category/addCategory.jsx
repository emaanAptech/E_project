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
  CFormTextarea,
  CRow,
  CTable,
  CTableBody,
  CTableDataCell,
  CTableHead,
  CTableHeaderCell,
  CTableRow,
} from '@coreui/react'
import { db } from '../../firebaseConfig/firebase'
import { collection, addDoc, getDocs, deleteDoc, updateDoc, doc } from 'firebase/firestore'

const AddCategory = () => {
  const [categoryData, setCategoryData] = useState({
    categoryName: '',
    categoryDescription: '',
    categoryImage: null,
  })
  const [categories, setCategories] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [successMessage, setSuccessMessage] = useState('')
  const [editMode, setEditMode] = useState(false)
  const [editId, setEditId] = useState(null)

  const categoriesCollection = collection(db, 'categories')

  // Fetch categories from Firestore
  const fetchCategories = async () => {
    const data = await getDocs(categoriesCollection)
    setCategories(data.docs.map((doc) => ({ ...doc.data(), id: doc.id })))
  }

  useEffect(() => {
    fetchCategories()
  }, [])

  const handleInputChange = (e) => {
    const { id, value } = e.target
    setCategoryData({ ...categoryData, [id]: value })
  }

  const handleFileChange = (e) => {
    const { files } = e.target
    if (files && files[0]) {
      const file = files[0]
      const reader = new FileReader()
      reader.onloadend = () => {
        setCategoryData({ ...categoryData, categoryImage: reader.result })
      }
      reader.readAsDataURL(file)
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()

    if (!categoryData.categoryImage) {
      setError('Please upload a category image.')
      return
    }

    setLoading(true)
    setError(null)
    setSuccessMessage('')

    try {
      if (editMode) {
        // Update category
        const categoryDoc = doc(db, 'categories', editId)
        await updateDoc(categoryDoc, {
          categoryName: categoryData.categoryName,
          categoryDescription: categoryData.categoryDescription,
          categoryImage: categoryData.categoryImage,
        })
        setSuccessMessage('Category updated successfully!')
      } else {
        // Add category
        await addDoc(categoriesCollection, {
          categoryName: categoryData.categoryName,
          categoryDescription: categoryData.categoryDescription,
          categoryImage: categoryData.categoryImage,
        })
        setSuccessMessage('Category added successfully!')
      }

      // Reset form
      setCategoryData({
        categoryName: '',
        categoryDescription: '',
        categoryImage: null,
      })
      setEditMode(false)
      setEditId(null)
      fetchCategories()
    } catch (err) {
      console.error('Error saving category:', err)
      setError('Failed to save category.')
    } finally {
      setLoading(false)
    }
  }

  const handleEdit = (id) => {
    const category = categories.find((cat) => cat.id === id)
    setCategoryData({
      categoryName: category.categoryName,
      categoryDescription: category.categoryDescription,
      categoryImage: category.categoryImage,
    })
    setEditMode(true)
    setEditId(id)
  }

  const handleDelete = async (id) => {
    try {
      const categoryDoc = doc(db, 'categories', id)
      await deleteDoc(categoryDoc)
      setSuccessMessage('Category deleted successfully!')
      fetchCategories()
    } catch (err) {
      console.error('Error deleting category:', err)
      setError('Failed to delete category.')
    }
  }

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>{editMode ? 'Edit Category' : 'Add Category'}</strong>
          </CCardHeader>
          <CCardBody>
            <CForm onSubmit={handleSubmit}>
              <div className="mb-3">
                <CFormLabel htmlFor="categoryName">Category Name</CFormLabel>
                <CFormInput
                  type="text"
                  id="categoryName"
                  placeholder="Enter category name"
                  value={categoryData.categoryName}
                  onChange={handleInputChange}
                  required
                />
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="categoryDescription">Category Description</CFormLabel>
                <CFormTextarea
                  id="categoryDescription"
                  rows={3}
                  placeholder="Enter category description"
                  value={categoryData.categoryDescription}
                  onChange={handleInputChange}
                  required
                ></CFormTextarea>
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="categoryImage">Category Image</CFormLabel>
                <CFormInput
                  type="file"
                  id="categoryImage"
                  accept="image/*"
                  onChange={handleFileChange}
                  required={!editMode}
                />
              </div>
              {error && <p className="text-danger">{error}</p>}
              {successMessage && <p className="text-success">{successMessage}</p>}
              <CButton type="submit" color="primary" disabled={loading}>
                {loading ? (editMode ? 'Updating...' : 'Adding...') : editMode ? 'Update' : 'Submit'}
              </CButton>
            </CForm>
          </CCardBody>
        </CCard>

        <CCard>
          <CCardHeader>
            <strong>Categories</strong>
          </CCardHeader>
          <CCardBody>
            <CTable>
              <CTableHead>
                <CTableRow>
                  <CTableHeaderCell>Name</CTableHeaderCell>
                  <CTableHeaderCell>Description</CTableHeaderCell>
                  <CTableHeaderCell>Image</CTableHeaderCell>
                  <CTableHeaderCell>Update</CTableHeaderCell>
                  <CTableHeaderCell>Delete</CTableHeaderCell>
                </CTableRow>
              </CTableHead>
              <CTableBody>
                {categories.map((category) => (
                  <CTableRow key={category.id}>
                    <CTableDataCell>{category.categoryName}</CTableDataCell>
                    <CTableDataCell>{category.categoryDescription}</CTableDataCell>
                    <CTableDataCell>
                      <img src={category.categoryImage} alt={category.categoryName} width={50} />
                    </CTableDataCell>
                    <CTableDataCell>
                    <CButton
                        color="success"
                        size="sm"
                        className="me-2"
                        onClick={() => handleEdit(category)}
                      >
                        Update
                      </CButton>
                    </CTableDataCell>
                    <CTableDataCell>
                      <CButton
                        color="danger"
                        size="sm"
                        onClick={() => handleDelete(category.id)}
                      >
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

export default AddCategory
