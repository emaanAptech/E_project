import React, { useState, useEffect } from 'react';
import {
  CCard,
  CCardBody,
  CCardHeader,
  CCol,
  CRow,
} from '@coreui/react';
import { db } from '../../firebaseConfig/firebase';
import { collection, getDocs } from 'firebase/firestore';

const ViewProducts = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

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
    </CRow>
  );
};

export default ViewProducts;
