import React, { useState, useEffect } from 'react';
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
  CFormSelect,
  CRow,
} from '@coreui/react';
import { db } from '../../firebaseConfig/firebase';
import { collection, getDocs, addDoc } from 'firebase/firestore';

const AddProducts = () => {
  const [formData, setFormData] = useState({
    productName: '',
    productPrice: '',
    productDescription: '',
    productCategory: '',
    productImage: null,
  });

  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [successMessage, setSuccessMessage] = useState('');

  // Fetch categories from Firestore
  const fetchCategories = async () => {
    try {
      const categoryCollection = collection(db, 'categories');
      const categorySnapshot = await getDocs(categoryCollection);
      const categoryList = categorySnapshot.docs.map((doc) => ({
        id: doc.id,
        name: doc.data().categoryName,
      }));
      setCategories(categoryList);
    } catch (err) {
      console.error('Error fetching categories:', err);
      setError('Failed to load categories.');
    }
  };

  useEffect(() => {
    fetchCategories();
  }, []);

  // Handle input change
  // Handle input change
  const handleInputChange = (e) => {
    const { id, value } = e.target;

    // If the input is for productPrice, only allow integer values
    if (id === 'productPrice') {
      // Allow only digits (integer input)
      if (/^\d*$/.test(value)) {
        setFormData({ ...formData, [id]: value });
      }
    } else {
      setFormData({ ...formData, [id]: value });
    }
  };

  // Handle file input change (convert image to Base64)
  const handleFileChange = (e) => {
    const { files } = e.target;
    if (files && files[0]) {
      const file = files[0];
      const reader = new FileReader();
      reader.onloadend = () => {
        setFormData({ ...formData, productImage: reader.result });
      };
      reader.readAsDataURL(file); // Convert image to Base64
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!formData.productImage) {
      setError('Please upload a product image.');
      return;
    }

    setLoading(true);
    setError(null);
    setSuccessMessage('');

    try {
      const productsCollection = collection(db, 'products');
      await addDoc(productsCollection, {
        ...formData,
        createdAt: new Date(),
      });

      setFormData({
        productName: '',
        productPrice: '',
        productDescription: '',
        productCategory: '',
        productImage: null,
      });

      setSuccessMessage('Product added successfully!');
    } catch (err) {
      console.error('Error adding product:', err);
      setError('Failed to add product.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>Add Product</strong>
          </CCardHeader>
          <CCardBody>
            <CForm onSubmit={handleSubmit}>
              <div className="mb-3">
                <CFormLabel htmlFor="productName">Product Name</CFormLabel>
                <CFormInput
                  type="text"
                  id="productName"
                  placeholder="Enter product name"
                  value={formData.productName}
                  onChange={handleInputChange}
                  required
                />
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="productPrice">Product Price</CFormLabel>
                <CFormInput
                  type="number"
                  id="productPrice"
                  placeholder="Enter product price"
                  value={formData.productPrice}
                  onChange={handleInputChange}
                  required
                />
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="productCategory">Product Category</CFormLabel>
                <CFormSelect
                  id="productCategory"
                  value={formData.productCategory}
                  onChange={handleInputChange}
                  required
                >
                  <option value="">Select a category</option>
                  {categories.map((category) => (
                    <option key={category.id} value={category.name}>
                      {category.name}
                    </option>
                  ))}
                </CFormSelect>
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="productDescription">Product Description</CFormLabel>
                <CFormTextarea
                  id="productDescription"
                  rows={3}
                  placeholder="Enter product description"
                  value={formData.productDescription}
                  onChange={handleInputChange}
                  required
                ></CFormTextarea>
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="productImage">Product Image</CFormLabel>
                <CFormInput
                  type="file"
                  id="productImage"
                  accept="image/*"
                  onChange={handleFileChange}
                  required
                />
              </div>
              {error && <p className="text-danger">{error}</p>}
              {successMessage && <p className="text-success">{successMessage}</p>}
              <CButton type="submit" color="primary" disabled={loading}>
                {loading ? 'Adding...' : 'Submit'}
              </CButton>
            </CForm>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  );
};

export default AddProducts;
