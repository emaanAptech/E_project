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
    trendproductName: '',
    trendproductPrice: '',
    trendproductDescription: '',
    trendproductCategory: '',
    trendproductImage: null,
    isTrending: false,  // Added field to mark the product as trending
  });

  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [successMessage, setSuccessMessage] = useState('');
  const [trendingProducts, setTrendingProducts] = useState([]);  // Added state for trending products

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

  // Fetch trending products from Firestore
  const fetchTrendingProducts = async () => {
    try {
      const productsCollection = collection(db, 'Trendprod');
      const productSnapshot = await getDocs(productsCollection);
      const trendingList = productSnapshot.docs
        .filter((doc) => doc.data().isTrending)
        .map((doc) => doc.data());
      setTrendingProducts(trendingList);
    } catch (err) {
      console.error('Error fetching trending products:', err);
      setError('Failed to load trending products.');
    }
  };

  useEffect(() => {
    fetchCategories();
    fetchTrendingProducts();  // Fetch trending products on load
  }, []);

  // Handle input change
  const handleInputChange = (e) => {
    const { id, value } = e.target;
    setFormData({ ...formData, [id]: value });
  };

  // Handle file input change (convert image to Base64)
  const handleFileChange = (e) => {
    const { files } = e.target;
    if (files && files[0]) {
      const file = files[0];
      const reader = new FileReader();
      reader.onloadend = () => {
        setFormData({ ...formData, trendproductImage: reader.result });
      };
      reader.readAsDataURL(file); // Convert image to Base64
    }
  };

  // Handle submit
  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!formData.trendproductImage) {
      setError('Please upload a product image.');
      return;
    }

    setLoading(true);
    setError(null);
    setSuccessMessage('');

    try {
      const productsCollection = collection(db, 'Trendprod');
      await addDoc(productsCollection, {
        ...formData,
        createdAt: new Date(),
      });

      setFormData({
        trendproductName: '',
        trendproductPrice: '',
        trendproductDescription: '',
        trendproductCategory: '',
        trendproductImage: null,
        isTrending: false,  // Reset the trending status
      });

      setSuccessMessage('Product added successfully!');
      fetchTrendingProducts();  // Re-fetch the trending products after adding a new one
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
                <CFormLabel htmlFor="trendproductName">Product Name</CFormLabel>
                <CFormInput
                  type="text"
                  id="trendproductName"
                  placeholder="Enter product name"
                  value={formData.trendproductName}
                  onChange={handleInputChange}
                  required
                />
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="trendproductPrice">Product Price</CFormLabel>
                <CFormInput
                  type="number"
                  id="trendproductPrice"
                  placeholder="Enter product price"
                  value={formData.trendproductPrice}
                  onChange={handleInputChange}
                  required
                />
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="trendproductCategory">Product Category</CFormLabel>
                <CFormSelect
                  id="trendproductCategory"
                  value={formData.trendproductCategory}
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
                <CFormLabel htmlFor="trendproductDescription">Product Description</CFormLabel>
                <CFormTextarea
                  id="trendproductDescription"
                  rows={3}
                  placeholder="Enter product description"
                  value={formData.trendproductDescription}
                  onChange={handleInputChange}
                  required
                ></CFormTextarea>
              </div>
              <div className="mb-3">
                <CFormLabel htmlFor="trendproductImage">Product Image</CFormLabel>
                <CFormInput
                  type="file"
                  id="trendproductImage"
                  accept="image/*"
                  onChange={handleFileChange}
                  required
                />
              </div> &nbsp;
              <div className="mb-3">
                <CFormLabel htmlFor="isTrending">Mark as Trending</CFormLabel>
                &nbsp;
                <input
                  type="checkbox"
                  id="isTrending"
                  checked={formData.isTrending}
                  onChange={(e) =>
                    setFormData({ ...formData, isTrending: e.target.checked })
                  }
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

      {/* Display Trending Products */}
      <CCol xs={12}>
        <CCard>
          <CCardHeader>
            <strong>Trending Products</strong>
          </CCardHeader>
          <CCardBody>
            <CRow>
              {trendingProducts.length > 0 ? (
                trendingProducts.map((product, index) => (
                  <CCol key={index} xs={12} sm={6} lg={4}>
                    <CCard>
                      <CCardBody>
                        <img src={product.trendproductImage} alt={product.trendproductName} style={{ width: '100%' }} />
                        <h5>{product.trendproductName}</h5>
                        <p>{product.trendproductDescription}</p>
                        <p>{product.trendproductPrice}</p>
                      </CCardBody>
                    </CCard>
                  </CCol>
                ))
              ) : (
                <p>No trending products available.</p>
              )}
            </CRow>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  );
};

export default AddProducts;
