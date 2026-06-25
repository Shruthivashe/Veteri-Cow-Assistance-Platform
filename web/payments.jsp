<%-- 
    Document   : payments
    Created on : 9 Aug 2025, 5:46:27 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="java.util.*, java.text.DecimalFormat" %>
<%
    // Simulated cart data from session (replace with actual cart logic)
    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
    }

    double doctorFee = 500.0;
    double cartTotal = 0.0;
    for (Map<String, Object> item : cart) {
        double price = Double.parseDouble(item.get("price").toString());
        int qty = Integer.parseInt(item.get("quantity").toString());
        cartTotal += price * qty;
    }
    double totalAmount = cartTotal + doctorFee;

    DecimalFormat df = new DecimalFormat("0.00");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Payment</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8fbff; /* Snow white */
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 900px;
            margin: 50px auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        h1 {
            text-align: center;
            color: #00aaff; /* Sky blue */
            margin-bottom: 30px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
        }
        table th {
            background-color: #00aaff; /* Sky blue */
            color: white;
            padding: 12px;
            text-align: left;
        }
        table td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        .total-row {
            font-weight: bold;
            background-color: #f0fff0; /* Light green tint */
        }
        .btn-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .btn {
            padding: 12px 25px;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s ease;
        }
        .home-btn {
            background-color: #00aaff;
            color: white;
        }
        .home-btn:hover {
            background-color: #0090cc;
        }
        .pay-btn {
            background-color: #90ee90; /* Light green */
            color: black;
        }
        .pay-btn:hover {
            background-color: #76d976;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Payment Summary</h1>

    <table>
        <tr>
            <th>Item</th>
            <th>Price (₹)</th>
            <th>Quantity</th>
            <th>Subtotal (₹)</th>
        </tr>
        <%
            for (Map<String, Object> item : cart) {
                double price = Double.parseDouble(item.get("price").toString());
                int qty = Integer.parseInt(item.get("quantity").toString());
                double subtotal = price * qty;
        %>
        <tr>
            <td><%= item.get("name") %></td>
            <td><%= df.format(price) %></td>
            <td><%= qty %></td>
            <td><%= df.format(subtotal) %></td>
        </tr>
        <% } %>
        <tr>
            <td colspan="3"><strong>Doctor Fee</strong></td>
            <td><%= df.format(doctorFee) %></td>
        </tr>
        <tr class="total-row">
            <td colspan="3">Total Amount</td>
            <td>₹ <%= df.format(totalAmount) %></td>
        </tr>
    </table>

    <div class="btn-container">
        <button class="btn home-btn" onclick="window.location.href='user_dashboard.jsp'">🏠 Home</button>
        <button class="btn pay-btn" id="payBtn">💳 Pay Now</button>
    </div>
</div>

<!-- Razorpay Script -->
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
document.getElementById('payBtn').onclick = function(e){
    var options = {
        "key": "rzp_test_5PcRUmrVhPJMLa", // Replace with your Razorpay Key
        "amount": "<%= (int)(totalAmount * 100) %>", // amount in paise
        "currency": "INR",
        "name": "CattleCare Pro",
        "description": "Veterinary Payment",
        "handler": function (response){
            alert("Payment Successful! Payment ID: " + response.razorpay_payment_id);
            // You can redirect to success page here
        },
        "theme": {
            "color": "#00aaff" // Sky blue
        }
    };
    var rzp1 = new Razorpay(options);
    rzp1.open();
    e.preventDefault();
}
</script>

</body>
</html>
