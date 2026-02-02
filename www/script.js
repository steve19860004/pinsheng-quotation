// Global state
let currentQuotationId = null;
let itemCount = 0;

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    initializeNewQuotation();
    loadHistoryList();
});

// Initialize new quotation
function initializeNewQuotation() {
    currentQuotationId = null;
    document.getElementById('quotationNumber').value = generateQuotationNumber();
    document.getElementById('quotationDate').value = getTodayDate();
    document.getElementById('customerName').value = '';
    document.getElementById('customerPhone').value = '';
    document.getElementById('customerAddress').value = '';
    document.getElementById('notes').value = '';
    document.getElementById('itemsTableBody').innerHTML = '';
    itemCount = 0;
    addItem(); // Add first item by default
    calculateTotals();
}

// Generate quotation number
function generateQuotationNumber() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const time = String(now.getHours()).padStart(2, '0') + String(now.getMinutes()).padStart(2, '0');
    return `Q${year}${month}${day}-${time}`;
}

// Get today's date in YYYY-MM-DD format
function getTodayDate() {
    const now = new Date();
    return now.toISOString().split('T')[0];
}

// Add new item row
function addItem() {
    itemCount++;
    const tbody = document.getElementById('itemsTableBody');
    const row = tbody.insertRow();
    row.innerHTML = `
        <td class="item-number">${itemCount}</td>
        <td><input type="text" class="item-name" placeholder="空調設備名稱" oninput="calculateTotals()"></td>
        <td><input type="text" class="item-spec" placeholder="規格型號" oninput="calculateTotals()"></td>
        <td><input type="number" class="item-qty" value="1" min="0" step="1" oninput="calculateTotals()"></td>
        <td><input type="number" class="item-price" value="0" min="0" step="1" oninput="calculateTotals()"></td>
        <td class="item-amount">NT$ 0</td>
        <td class="no-print">
            <button class="btn btn-danger btn-small" onclick="removeItem(this)">
                <span class="icon">🗑️</span>
            </button>
        </td>
    `;
}

// Remove item row
function removeItem(btn) {
    const row = btn.closest('tr');
    row.remove();
    renumberItems();
    calculateTotals();
}

// Renumber items after deletion
function renumberItems() {
    const rows = document.getElementById('itemsTableBody').querySelectorAll('tr');
    itemCount = 0;
    rows.forEach(row => {
        itemCount++;
        row.querySelector('.item-number').textContent = itemCount;
    });
}

// Calculate totals
function calculateTotals() {
    const rows = document.getElementById('itemsTableBody').querySelectorAll('tr');
    let subtotal = 0;

    rows.forEach(row => {
        const qty = parseFloat(row.querySelector('.item-qty').value) || 0;
        const price = parseFloat(row.querySelector('.item-price').value) || 0;
        const amount = qty * price;
        row.querySelector('.item-amount').textContent = `NT$ ${formatNumber(amount)}`;
        subtotal += amount;
    });

    const tax = subtotal * 0.05;
    const grandTotal = subtotal + tax;

    document.getElementById('subtotal').textContent = `NT$ ${formatNumber(subtotal)}`;
    document.getElementById('tax').textContent = `NT$ ${formatNumber(tax)}`;
    document.getElementById('grandTotal').textContent = `NT$ ${formatNumber(grandTotal)}`;
}

// Format number with commas
function formatNumber(num) {
    return Math.round(num).toLocaleString('zh-TW');
}

// Save quotation
function saveQuotation() {
    const customerName = document.getElementById('customerName').value.trim();
    
    if (!customerName) {
        alert('請輸入客戶名稱！');
        document.getElementById('customerName').focus();
        return;
    }

    const rows = document.getElementById('itemsTableBody').querySelectorAll('tr');
    if (rows.length === 0) {
        alert('請至少新增一個報價項目！');
        return;
    }

    // Collect items
    const items = [];
    rows.forEach(row => {
        items.push({
            name: row.querySelector('.item-name').value,
            spec: row.querySelector('.item-spec').value,
            qty: parseFloat(row.querySelector('.item-qty').value) || 0,
            price: parseFloat(row.querySelector('.item-price').value) || 0
        });
    });

    // Create quotation object
    const quotation = {
        id: currentQuotationId || generateQuotationNumber(),
        number: document.getElementById('quotationNumber').value,
        date: document.getElementById('quotationDate').value,
        customerName: customerName,
        customerPhone: document.getElementById('customerPhone').value,
        customerAddress: document.getElementById('customerAddress').value,
        items: items,
        notes: document.getElementById('notes').value,
        subtotal: parseFloat(document.getElementById('subtotal').textContent.replace(/[^\d]/g, '')),
        tax: parseFloat(document.getElementById('tax').textContent.replace(/[^\d]/g, '')),
        grandTotal: parseFloat(document.getElementById('grandTotal').textContent.replace(/[^\d]/g, '')),
        createdAt: new Date().toISOString()
    };

    // Save to localStorage
    let quotations = JSON.parse(localStorage.getItem('quotations') || '[]');
    
    const existingIndex = quotations.findIndex(q => q.id === quotation.id);
    if (existingIndex >= 0) {
        quotations[existingIndex] = quotation;
        alert('報價單已更新！');
    } else {
        quotations.push(quotation);
        alert('報價單已儲存！');
    }

    localStorage.setItem('quotations', JSON.stringify(quotations));
    currentQuotationId = quotation.id;
    loadHistoryList();
}

// Load quotation
function loadQuotation(id) {
    const quotations = JSON.parse(localStorage.getItem('quotations') || '[]');
    const quotation = quotations.find(q => q.id === id);
    
    if (!quotation) {
        alert('找不到該報價單！');
        return;
    }

    currentQuotationId = quotation.id;
    document.getElementById('quotationNumber').value = quotation.number;
    document.getElementById('quotationDate').value = quotation.date;
    document.getElementById('customerName').value = quotation.customerName;
    document.getElementById('customerPhone').value = quotation.customerPhone || '';
    document.getElementById('customerAddress').value = quotation.customerAddress || '';
    document.getElementById('notes').value = quotation.notes || '';

    // Load items
    const tbody = document.getElementById('itemsTableBody');
    tbody.innerHTML = '';
    itemCount = 0;

    quotation.items.forEach(item => {
        itemCount++;
        const row = tbody.insertRow();
        row.innerHTML = `
            <td class="item-number">${itemCount}</td>
            <td><input type="text" class="item-name" value="${item.name}" placeholder="空調設備名稱" oninput="calculateTotals()"></td>
            <td><input type="text" class="item-spec" value="${item.spec}" placeholder="規格型號" oninput="calculateTotals()"></td>
            <td><input type="number" class="item-qty" value="${item.qty}" min="0" step="1" oninput="calculateTotals()"></td>
            <td><input type="number" class="item-price" value="${item.price}" min="0" step="1" oninput="calculateTotals()"></td>
            <td class="item-amount">NT$ 0</td>
            <td class="no-print">
                <button class="btn btn-danger btn-small" onclick="removeItem(this)">
                    <span class="icon">🗑️</span>
                </button>
            </td>
        `;
    });

    calculateTotals();
    toggleHistory(); // Close history panel
}

// Delete quotation
function deleteQuotation() {
    if (!currentQuotationId) {
        alert('目前沒有可刪除的報價單！');
        return;
    }

    if (!confirm('確定要刪除此報價單嗎？此操作無法復原！')) {
        return;
    }

    let quotations = JSON.parse(localStorage.getItem('quotations') || '[]');
    quotations = quotations.filter(q => q.id !== currentQuotationId);
    localStorage.setItem('quotations', JSON.stringify(quotations));
    
    alert('報價單已刪除！');
    newQuotation();
    loadHistoryList();
}

// New quotation
function newQuotation() {
    if (currentQuotationId) {
        if (!confirm('目前的報價單尚未儲存，確定要建立新報價單嗎？')) {
            return;
        }
    }
    initializeNewQuotation();
}

// Print quotation
function printQuotation() {
    window.print();
}

// Toggle history panel
function toggleHistory() {
    const panel = document.getElementById('historyPanel');
    panel.classList.toggle('active');
}

// Load history list
function loadHistoryList() {
    const quotations = JSON.parse(localStorage.getItem('quotations') || '[]');
    const historyList = document.getElementById('historyList');
    
    if (quotations.length === 0) {
        historyList.innerHTML = '<p style="text-align: center; color: #64748b; padding: 2rem;">尚無歷史報價單</p>';
        return;
    }

    // Sort by date (newest first)
    quotations.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

    historyList.innerHTML = quotations.map(q => `
        <div class="history-item" onclick="loadQuotation('${q.id}')">
            <div class="history-item-header">
                <span class="history-item-number">${q.number}</span>
                <span class="history-item-date">${formatDate(q.date)}</span>
            </div>
            <div class="history-item-customer">${q.customerName}</div>
            <div class="history-item-total">總計: NT$ ${formatNumber(q.grandTotal)}</div>
        </div>
    `).join('');
}

// Filter history
function filterHistory() {
    const searchTerm = document.getElementById('searchHistory').value.toLowerCase();
    const items = document.querySelectorAll('.history-item');
    
    items.forEach(item => {
        const text = item.textContent.toLowerCase();
        if (text.includes(searchTerm)) {
            item.style.display = 'block';
        } else {
            item.style.display = 'none';
        }
    });
}

// Format date for display
function formatDate(dateString) {
    const date = new Date(dateString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}/${month}/${day}`;
}

// Export to PDF
async function exportPDF() {
    const customerName = document.getElementById('customerName').value.trim();
    
    if (!customerName) {
        alert('請先輸入客戶名稱！');
        return;
    }

    // Show loading message
    const originalContent = document.body.innerHTML;
    
    try {
        // Get the jsPDF constructor
        const { jsPDF } = window.jspdf;
        
        // Create new PDF document
        const pdf = new jsPDF('p', 'mm', 'a4');
        
        // Use html2canvas to capture the main content
        const element = document.querySelector('.container');
        const canvas = await html2canvas(element, {
            scale: 2,
            useCORS: true,
            logging: false
        });
        
        const imgData = canvas.toDataURL('image/png');
        const imgWidth = 210; // A4 width in mm
        const imgHeight = (canvas.height * imgWidth) / canvas.width;
        
        pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);
        
        // Generate filename
        const quotationNumber = document.getElementById('quotationNumber').value;
        const filename = `品盛報價單_${customerName}_${quotationNumber}.pdf`;
        
        // Save PDF
        pdf.save(filename);
        
        alert('PDF 已成功匯出！');
    } catch (error) {
        console.error('PDF 匯出失敗:', error);
        alert('PDF 匯出失敗，請稍後再試！');
    }
}

// Export data to JSON file
function exportData() {
    const quotations = localStorage.getItem('quotations');
    
    if (!quotations || quotations === '[]') {
        alert('目前沒有任何報價資料可以匯出！');
        return;
    }
    
    try {
        // Create JSON blob
        const blob = new Blob([quotations], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        
        // Create download link
        const a = document.createElement('a');
        a.href = url;
        a.download = `品盛報價資料_${new Date().toISOString().split('T')[0]}.json`;
        document.body.appendChild(a);
        a.click();
        
        // Cleanup
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        
        alert('資料已成功匯出！');
    } catch (error) {
        console.error('資料匯出失敗:', error);
        alert('資料匯出失敗，請稍後再試！');
    }
}

// Import data from JSON file
function importData() {
    if (!confirm('匯入資料將會覆蓋現有的所有報價資料，確定要繼續嗎？')) {
        return;
    }
    
    // Create file input
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = 'application/json';
    
    input.onchange = function(e) {
        const file = e.target.files[0];
        if (!file) return;
        
        const reader = new FileReader();
        reader.onload = function(event) {
            try {
                const data = JSON.parse(event.target.result);
                
                // Validate data
                if (!Array.isArray(data)) {
                    alert('檔案格式錯誤！請選擇正確的備份檔案。');
                    return;
                }
                
                // Import data
                localStorage.setItem('quotations', JSON.stringify(data));
                loadHistoryList();
                
                alert(`成功匯入 ${data.length} 筆報價資料！`);
            } catch (error) {
                console.error('資料匯入失敗:', error);
                alert('資料匯入失敗！請確認檔案格式正確。');
            }
        };
        
        reader.readAsText(file);
    };
    
    input.click();
}
