import React, { useEffect, useState } from 'react';
import { CRow, CCol, CCard, CCardHeader, CCardBody, CTable, CTableHead, CTableRow, CTableHeaderCell, CTableBody, CTableDataCell } from '@coreui/react';
import { db } from '../../firebaseConfig/firebase';
import { collection, getDocs } from 'firebase/firestore';

const FeedbackPage = () => {
  const [feedbackList, setFeedbackList] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Fetch feedback from Firestore
  const fetchFeedback = async () => {
    try {
      setLoading(true);
      const feedbackSnapshot = await getDocs(collection(db, 'feedback'));
      const feedbackData = feedbackSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      setFeedbackList(feedbackData);
      setError(null);  // Clear any previous error
    } catch (err) {
      console.error('Error fetching feedback:', err);
      setError('Failed to load feedback.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchFeedback();
  }, []);

  if (loading) {
    return <p>Loading feedback...</p>;
  }

  if (error) {
    return <p className="text-danger">{error}</p>;
  }

  return (
    <CRow>
      <CCol xs={12}>
        <CCard className="mb-4">
          <CCardHeader>
            <strong>Feedback List</strong>
          </CCardHeader>
          <CCardBody>
            <CTable>
              <CTableHead>
                <CTableRow>
                  <CTableHeaderCell>#</CTableHeaderCell>
                  <CTableHeaderCell>Email</CTableHeaderCell>
                  <CTableHeaderCell>Feedback</CTableHeaderCell>
                  <CTableHeaderCell>Submitted At</CTableHeaderCell>
                </CTableRow>
              </CTableHead>
              <CTableBody>
                {feedbackList.map((feedback, index) => (
                  <CTableRow key={feedback.id}>
                    <CTableHeaderCell>{index + 1}</CTableHeaderCell>
                    <CTableDataCell>{feedback.email}</CTableDataCell>
                    <CTableDataCell>{feedback.feedback}</CTableDataCell>
                    <CTableDataCell>{new Date(feedback.timestamp?.seconds * 1000).toLocaleString()}</CTableDataCell>
                  </CTableRow>
                ))}
              </CTableBody>
            </CTable>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  );
};

export default FeedbackPage;
