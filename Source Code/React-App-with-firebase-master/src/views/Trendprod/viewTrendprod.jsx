import React, { useState, useEffect } from 'react';
import {
  CCard,
  CCardBody,
  CCardHeader,
  CCol,
  CRow,
  CButton,
  CModal,
  CModalHeader,
  CModalBody,
  CModalFooter,
  CFormInput,
  CFormTextarea
} from '@coreui/react';
import { db } from '../../firebaseConfig/firebase';
import { collection, getDocs, updateDoc, deleteDoc, doc } from 'firebase/firestore';
import { getStorage, ref, uploadBytes, getDownloadURL } from 'firebase/storage';

const ViewProducts = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // States for the edit modal
  const [editModalVisible, setEditModalVisible] = useState(false);
  const [editData, setEditData] = useState({
    id: '',
    trendproductName: '',
    trendproductPrice: '',
    trendproductDescription: '',
    trendproductImage: ''
  });

  const [newImageFile, setNewImageFile] = useState(null); // For storing the selected new image

  const storage = getStorage();

  // Fetch all products from Firestore
  const fetchProducts = async () => {
    setLoading(true);
    try {
      const productsCollection = collection(db, 'Trendprod');
      const productSnapshot = await getDocs(productsCollection);
      const productList = productSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      setProducts(productList);
    } catch (err) {
      console.error('Error fetching products:', err);
      setError('Failed to load products.');
    } finally {
      setLoading(false);
    }
  };

  // Handle edit button click
  const handleEdit = (product) => {
    setEditData(product);
    setEditModalVisible(true); // Open the modal
  };

  // Handle form input changes in the modal
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setEditData({ ...editData, [name]: value });
  };

  // Handle new image file selection
  const handleFileChange = (e) => {
    const file = e.target.files[0];
    setNewImageFile(file); // Store the selected file
    setEditData({ ...editData, trendproductImage: URL.createObjectURL(file) }); // Preview the image
  };

  // Save updated product details to Firestore
  const handleSaveEdit = async () => {
    try {
      let updatedImage = editData.trendproductImage; // Save the current image
  
      // If there's a new image, upload it to Firebase Storage
      if (newImageFile) {
        const storageRef = ref(storage, `product_images/${newImageFile.name}`);
        await uploadBytes(storageRef, newImageFile);
        updatedImage = await getDownloadURL(storageRef); // Get the URL of the uploaded image
      }
  
      const productRef = doc(db, 'Trendprod', editData.id);
      await updateDoc(productRef, {
        trendproductName: editData.trendproductName,
        trendproductPrice: editData.trendproductPrice,
        trendproductDescription: editData.trendproductDescription,
        trendproductImage: updatedImage,  // Update with new or existing image
      });
  
      setEditModalVisible(false);  // Close the modal after saving
      fetchProducts(); // Refresh product list
      setNewImageFile(null); // Clear the new image file after saving
  
    } catch (err) {
      console.error('Error updating product:', err);
      setError('Failed to update product.');
    }
  };
  

  // Delete product from Firestore
// Assuming 'productId' is the id of the product you want to delete
const handleDelete = async (productId) => {
  try {
    const productRef = doc(db, 'Trendprod', productId);
    await deleteDoc(productRef);
    fetchProducts(); // Refresh the product list after deletion
  } catch (err) {
    console.error('Error deleting product:', err);
    setError('Failed to delete product.');
  }
};

  useEffect(() => {
    fetchProducts();  // Fetch products on page load
  }, []);

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>All Products</strong>
          </CCardHeader>
          <CCardBody>
            {loading ? (
              <p>Loading products...</p>
            ) : error ? (
              <p className="text-danger">{error}</p>
            ) : (
              <CRow>
                {products.length > 0 ? (
                  products.map((product, index) => (
                    <CCol key={index} xs={12} sm={6} lg={4}>
                      <CCard>
                        <CCardBody>
                          <img
                            src={product.trendproductImage}
                            alt={product.trendproductName}
                            style={{ width: '100%' }}
                          />
                          <h5>{product.trendproductName}</h5>
                          <p>{product.trendproductDescription}</p>
                          <p>{product.trendproductPrice}</p>
                          <p>
                            <strong>Trending: </strong>
                            {product.isTrending ? 'Yes' : 'No'}
                          </p>
                          <CButton
                            color="primary"
                            onClick={() => handleEdit(product)} // Open the modal
                          >
                            Update
                          </CButton>
                          <CButton
                            color="danger"
                            onClick={() => handleDelete(product.id)}
                            style={{ marginLeft: '10px' }}
                          >
                            Delete
                          </CButton>
                        </CCardBody>
                      </CCard>
                    </CCol>
                  ))
                ) : (
                  <p>No products available.</p>
                )}
              </CRow>
            )}
          </CCardBody>
        </CCard>
      </CCol>

      {/* Edit Modal */}
      <CModal visible={editModalVisible} onClose={() => setEditModalVisible(false)}>
        <CModalHeader>Edit Product</CModalHeader>
        <CModalBody>
          {editData && (
            <>
              <CFormInput
                name="trendproductName"
                label="Product Name"
                value={editData.trendproductName}
                onChange={handleInputChange}
              />
              <CFormInput
                name="trendproductPrice"
                label="Product Price"
                value={editData.trendproductPrice}
                onChange={handleInputChange}
                type="number"
                step="0.01"
              />
              <CFormTextarea
                name="trendproductDescription"
                label="Product Description"
                value={editData.trendproductDescription}
                onChange={handleInputChange}
              />

              {/* Image upload input */}
              <div className="mt-3">
                <label>Product Image:</label>
                <input
                  type="file"
                  onChange={handleFileChange}
                  className="form-control"
                />
                {newImageFile && (
                  <div>
                    <p>Selected Image:</p>
                    <img
                      src={URL.createObjectURL(newImageFile)}
                      alt="Preview"
                      style={{ width: '100px' }}
                    />
                  </div>
                )}
              </div>
            </>
          )}
        </CModalBody>
        <CModalFooter>
          <CButton color="primary" onClick={handleSaveEdit}>
            Save
          </CButton>
          <CButton color="secondary" onClick={() => setEditModalVisible(false)}>
            Cancel
          </CButton>
        </CModalFooter>
      </CModal>
    </CRow>
  );
};

export default ViewProducts;
