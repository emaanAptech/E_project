import React, { useEffect, useState } from 'react';
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
  CModal,
  CModalHeader,
  CModalBody,
  CModalFooter,
  CFormInput,
  CFormTextarea,
} from '@coreui/react';
import { db } from '../../firebaseConfig/firebase';
import { collection, getDocs, doc, deleteDoc, updateDoc } from 'firebase/firestore';
import { ref, uploadBytes, getDownloadURL, getStorage, listAll } from 'firebase/storage';


const ViewProducts = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);


  // States for editing
  const [editModalVisible, setEditModalVisible] = useState(false);
  const [editData, setEditData] = useState(null);
  const [imageList, setImageList] = useState([]); // State to hold list of images
  const [newImageFile, setNewImageFile] = useState(null); // State to hold file for new image upload

  // Initialize Firebase storage
  const storage = getStorage();

  // Fetch products from Firestore
  const fetchProducts = async () => {
    try {
      const productsCollection = collection(db, 'products');
      const productsSnapshot = await getDocs(productsCollection);
      const productList = productsSnapshot.docs.map((doc) => ({
        id: doc.id, // Include the document ID
        ...doc.data(),
      }));
      console.log('Fetched products:', productList);
      setProducts(productList);
    } catch (err) {
      console.error('Error fetching products:', err);
      setError('Failed to load products.');
    } finally {
      setLoading(false);
    }
  };

  // Fetch image list (from Firebase storage)
  const fetchImages = async () => {
    try {
      const imagesRef = ref(storage, 'product_images/');
      const result = await listAll(imagesRef);
      const urls = await Promise.all(result.items.map((item) => getDownloadURL(item)));
      console.log('Fetched images:', urls);
      setImageList(urls);
    } catch (error) {
      console.error('Error fetching images:', error);
      setImageList([]);
    }
  };

  useEffect(() => {
    fetchProducts();
    fetchImages();
  }, []);

  // Handle edit button click
  const handleEdit = (product) => {
    setEditData(product);
    setEditModalVisible(true);
  };

  // Save changes to Firestore
  const handleSaveEdit = async () => {
    try {
      let updatedImage = editData.productImage; // Keep the current image if no new image is selected

      // If there's a new image file, upload it to Firebase Storage
      if (newImageFile) {
        console.log('Uploading new image...');

        // Create a reference to Firebase storage location
        const storageRef = ref(storage, `product_images/${newImageFile.name}`);

        // Upload the file to Firebase Storage
        await uploadBytes(storageRef, newImageFile);

        // Get the URL of the uploaded image
        updatedImage = await getDownloadURL(storageRef); // Get the image URL from Firebase Storage

        console.log('New image uploaded to Firebase Storage:', updatedImage);
      }

      // Now update Firestore document with the new image URL (or the existing image URL if no new image)
      const productRef = doc(db, 'products', editData.id);

      await updateDoc(productRef, {
        productName: editData.productName,
        productPrice: editData.productPrice,
        productDescription: editData.productDescription,
        productImage: updatedImage, // Set the updated image URL
      });

      // Close the modal and refresh the product list
      console.log('Product updated successfully in Firestore');
      setEditModalVisible(false);
      fetchProducts(); // Refresh product list

      // Clear the file input and image preview after saving
      setNewImageFile(null);
    } catch (err) {
      console.error('Error updating product:', err);
      setError('Failed to update product.');
    }
  };



  // Handle delete
  const handleDelete = async (productId) => {
    try {
      const productRef = doc(db, 'products', productId);
      await deleteDoc(productRef);
      fetchProducts(); // Refresh product list
    } catch (err) {
      console.error('Error deleting product:', err);
      setError('Failed to delete product.');
    }
  };

  // Handle edit form input changes
  const handleEditInputChange = (e) => {
    const { name, value } = e.target;
    setEditData({ ...editData, [name]: value });
  };

  // Handle image selection from existing images
  const handleImageSelect = (image) => {
    setEditData({ ...editData, productImage: image });
    setNewImageFile(null); // Clear file input if an image from the list is selected
  };

  // Handle new image file upload
  const handleFileChange = (e) => {
    const file = e.target.files[0];
    setNewImageFile(file);
    setEditData({ ...editData, productImage: URL.createObjectURL(file) }); // Show the selected file as a preview
  };

  if (loading) {
    return <p>Loading products...</p>;
  }

  if (error) {
    return <p className="text-danger">{error}</p>;
  }

  return (
    <>
      <CRow>
        <CCol xs={12}>
          <CCard className="mb-4">
            <CCardHeader>
              <strong>Product List</strong>
            </CCardHeader>
            <CCardBody>
              <CTable>
                <CTableHead>
                  <CTableRow>
                    <CTableHeaderCell>#</CTableHeaderCell>
                    <CTableHeaderCell>Product Name</CTableHeaderCell>
                    <CTableHeaderCell>Price</CTableHeaderCell>
                    <CTableHeaderCell>Description</CTableHeaderCell>
                    <CTableHeaderCell>Image</CTableHeaderCell>
                    <CTableHeaderCell>Update</CTableHeaderCell>
                    <CTableHeaderCell>Delete</CTableHeaderCell>

                  </CTableRow>
                </CTableHead>
                <CTableBody>
                  {products.map((product, index) => (
                    <CTableRow key={product.id}>
                      <CTableHeaderCell>{index + 1}</CTableHeaderCell>
                      <CTableDataCell>{product.productName}</CTableDataCell>
                      <CTableDataCell>{product.productPrice}</CTableDataCell>
                      <CTableDataCell>{product.productDescription}</CTableDataCell>
                      <CTableDataCell>
                        {product.productImage && (
                          <img src={product.productImage} alt="Product" style={{ width: '50px' }} />
                        )}
                      </CTableDataCell>
                      <CTableDataCell>
                        <CButton
                          style={{
                            backgroundColor: '#28a745', // Green
                            color: 'white',
                            border: 'none',
                            padding: '5px 10px',
                            fontSize: '14px',
                            cursor: 'pointer',
                          }}
                          size="sm"
                          onClick={() => handleEdit(product)}
                        >
                          Update
                        </CButton>
                      </CTableDataCell>
                      <CTableDataCell>
                        <CButton
                          style={{
                            backgroundColor: '#dc3545', // Red
                            color: 'white',
                            border: 'none',
                            padding: '5px 10px',
                            fontSize: '14px',
                            cursor: 'pointer',
                          }}
                          size="sm"
                          onClick={() => handleDelete(product.id)}
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

      {/* Edit Modal */}
      <CModal visible={editModalVisible} onClose={() => setEditModalVisible(false)}>
        <CModalHeader>Edit Product</CModalHeader>
        <CModalBody>
          {editData && (
            <>
              <CFormInput
                name="productName"
                value={editData.productName}
                onChange={handleEditInputChange}
                label="Product Name"
              />
              <CFormInput
                name="productPrice"
                value={editData.productPrice}
                onChange={handleEditInputChange}
                label="Product Price"
                type="number" // Changed to number
                step="1" // Restrict to integer values only
              />
              <CFormTextarea
                name="productDescription"
                value={editData.productDescription}
                onChange={handleEditInputChange}
                label="Product Description"
              />
              <div>
                <strong>Product Image:</strong>
                {editData.productImage && (
                  <div>
                    <img src={editData.productImage} alt="Current Product" style={{ width: '100px', margin: '10px 0' }} />
                    <p>Current Image</p>
                  </div>
                )}
                {/* <div>
                  <label>Select New Image:</label>
                  <select
                    value={editData.productImage}
                    onChange={(e) => handleImageSelect(e.target.value)}
                    className="form-select"
                  >
                    <option value="">-- Select Image --</option>
                    {imageList.map((image, index) => (
                      <option key={index} value={image}>
                        {image}
                      </option>
                    ))}
                  </select>
                </div> */}
                <div>
                  <label>Upload Image: </label>
                  <input type="file" onChange={handleFileChange} />
                  {newImageFile && (
                    <div>
                      <p>Selected Image:</p>
                      <img src={URL.createObjectURL(newImageFile)} alt="Preview" style={{ width: '100px' }} />
                    </div>
                  )}
                </div>
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
    </>
  );
};

export default ViewProducts;
