import React, { useState, useEffect } from 'react';
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
    CSpinner,
} from '@coreui/react';
import { db } from '../../firebaseConfig/firebase'; // Firebase configuration
import { collection, getDocs, doc, deleteDoc, updateDoc } from 'firebase/firestore';

const ViewOrders = () => {
    const [orders, setOrders] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    // States for editing
    const [editModalVisible, setEditModalVisible] = useState(false);
    const [editData, setEditData] = useState(null);

    // Fetch orders from Firestore
    const fetchOrders = async () => {
        try {
            const ordersCollection = collection(db, 'orders');
            const ordersSnapshot = await getDocs(ordersCollection);
            const orderList = ordersSnapshot.docs.map((doc) => ({
                id: doc.id,
                ...doc.data(),
            }));
            console.log(orderList);  // Log fetched data to verify 'totalPrice'
            setOrders(orderList);
        } catch (err) {
            console.error('Error fetching orders:', err);
            setError('Failed to load orders.');
        } finally {
            setLoading(false);
        }
    };
    

    useEffect(() => {
        fetchOrders();
    }, []);

    // Handle edit button click
    const handleEdit = (order) => {
        setEditData({ ...order }); // Ensure we don't directly mutate the state
        setEditModalVisible(true);
    };

    // Handle save and pass totalAmount
    const handleSaveEdit = async () => {
        if (
            !editData.customerName ||
            !editData.customerEmail ||
            !editData.shippingAddress ||
            !editData.paymentMethod ||
            !editData.totalAmount
        ) {
            alert("All fields are required!");
            return;
        }

        try {
            const orderRef = doc(db, 'orders', editData.id);
            await updateDoc(orderRef, {
                customerName: editData.customerName,
                customerEmail: editData.customerEmail,
                customerPhone: editData.customerPhone,
                shippingAddress: editData.shippingAddress,
                paymentMethod: editData.paymentMethod,
                totalAmount: editData.totalAmount, // Ensure totalAmount is included
            });
            setEditModalVisible(false);
            fetchOrders(); // Refresh order list
        } catch (err) {
            console.error('Error updating order:', err);
            setError('Failed to update order.');
        }
    };

    // Handle delete
    const handleDelete = async (orderId) => {
        if (window.confirm('Are you sure you want to delete this order?')) {
            try {
                const orderRef = doc(db, 'orders', orderId);
                await deleteDoc(orderRef);
                fetchOrders(); // Refresh order list after deletion
            } catch (err) {
                console.error('Error deleting order:', err);
                setError('Failed to delete order.');
            }
        }
    };

    // Handle edit form input changes
    const handleEditInputChange = (e) => {
        const { name, value } = e.target;
        setEditData({ ...editData, [name]: value });
    };

    if (loading) {
        return <CSpinner color="primary" />;
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
                            <strong>Order List</strong>
                        </CCardHeader>
                        <CCardBody>
                            <CTable>
                                <CTableHead>
                                    <CTableRow>
                                        <CTableHeaderCell>#</CTableHeaderCell>
                                        <CTableHeaderCell>Customer Name</CTableHeaderCell>
                                        <CTableHeaderCell>Customer Email</CTableHeaderCell>
                                        <CTableHeaderCell>Customer Phone</CTableHeaderCell>
                                        <CTableHeaderCell>Shipping Address</CTableHeaderCell>
                                        <CTableHeaderCell>Order Date</CTableHeaderCell>
                                        <CTableHeaderCell>Payment Method</CTableHeaderCell>
                                        <CTableHeaderCell>Total Amount</CTableHeaderCell> {/* Renamed from Total Price */}
                                        <CTableHeaderCell>Update</CTableHeaderCell>
                                        <CTableHeaderCell>Delete</CTableHeaderCell>
                                    </CTableRow>
                                </CTableHead>
                                <CTableBody>
                                    {orders.map((order, index) => (
                                        <CTableRow key={order.id}>
                                            <CTableHeaderCell>{index + 1}</CTableHeaderCell>
                                            <CTableDataCell>{order.customerName}</CTableDataCell>
                                            <CTableDataCell>{order.customerEmail}</CTableDataCell>
                                            <CTableDataCell>{order.customerPhone}</CTableDataCell>
                                            <CTableDataCell>{order.shippingAddress}</CTableDataCell>
                                            <CTableDataCell>{order.timestamp?.toDate().toLocaleString()}</CTableDataCell>
                                            <CTableDataCell>{order.paymentMethod}</CTableDataCell>
                                            <CTableDataCell>{order.totalAmount || 'N/A'}</CTableDataCell> {/* Renamed to totalAmount */}
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
                                                    onClick={() => handleEdit(order)}
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
                                                    onClick={() => handleDelete(order.id)}
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
                <CModalHeader>Edit Order</CModalHeader>
                <CModalBody>
                    {editData && (
                        <>
                            <CFormInput
                                name="customerName"
                                value={editData.customerName}
                                onChange={handleEditInputChange}
                                label="Customer Name"
                            />
                            <CFormInput
                                name="customerEmail"
                                value={editData.customerEmail}
                                onChange={handleEditInputChange}
                                label="Customer Email"
                            />
                            <CFormInput
                                name="customerPhone"
                                value={editData.customerPhone}
                                onChange={handleEditInputChange}
                                label="Customer Phone Number"
                            />
                            <CFormTextarea
                                name="shippingAddress"
                                value={editData.shippingAddress}
                                onChange={handleEditInputChange}
                                label="Shipping Address"
                            />
                            <CFormInput
                                name="paymentMethod"
                                value={editData.paymentMethod || ''}
                                onChange={handleEditInputChange}
                                label="Payment Method"
                            />
                            <CFormInput
                                name="totalAmount"
                                value={editData.totalAmount || ''}
                                onChange={handleEditInputChange}
                                label="Total Amount"
                            />
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

export default ViewOrders;
