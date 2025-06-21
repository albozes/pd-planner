const canvas = document.getElementById('playdate');
const ctx = canvas.getContext('2d');
const imageLoader = document.getElementById('imageLoader');
const gridToggle = document.getElementById('gridToggle');
const bgToggle = document.getElementById('bgToggle');
const lineBtn = document.getElementById('lineBtn');
const lineWidth = document.getElementById('lineWidth');
const cursorPos = document.getElementById('cursorPos');

let drawingLine = false;
let lineStart = null;

function drawGrid() {
    if (gridToggle.checked) {
        canvas.parentElement.classList.add('grid');
    } else {
        canvas.parentElement.classList.remove('grid');
    }
}

function setBackground() {
    if (bgToggle.checked) {
        canvas.classList.add('dark');
    } else {
        canvas.classList.remove('dark');
    }
    draw();
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    // stored elements
    elements.forEach(e => e.draw(ctx));
}

class ImageElement {
    constructor(img, x, y) {
        this.img = img;
        this.x = x;
        this.y = y;
    }
    draw(ctx) { ctx.drawImage(this.img, this.x, this.y); }
}

class TextElement {
    constructor(text, x, y) {
        this.text = text;
        this.x = x;
        this.y = y;
    }
    draw(ctx) {
        ctx.fillStyle = bgToggle.checked ? '#fff' : '#000';
        ctx.font = '12px sans-serif';
        ctx.fillText(this.text, this.x, this.y);
    }
}

class LineElement {
    constructor(sx, sy, ex, ey, width) {
        this.sx = sx; this.sy = sy; this.ex = ex; this.ey = ey; this.width = width;
    }
    draw(ctx) {
        ctx.strokeStyle = bgToggle.checked ? '#fff' : '#000';
        ctx.lineWidth = this.width;
        ctx.beginPath();
        ctx.moveTo(this.sx, this.sy);
        ctx.lineTo(this.ex, this.ey);
        ctx.stroke();
    }
}

const elements = [];

imageLoader.addEventListener('change', e => {
    const file = e.target.files[0];
    if (!file) return;
    const img = new Image();
    img.onload = () => {
        elements.push(new ImageElement(img, 0, 0));
        draw();
    };
    img.src = URL.createObjectURL(file);
});

lineBtn.addEventListener('click', () => {
    drawingLine = !drawingLine;
    lineBtn.textContent = drawingLine ? 'Finish Line' : 'Draw Line';
    lineStart = null;
});

canvas.addEventListener('mousedown', e => {
    const rect = canvas.getBoundingClientRect();
    const x = Math.floor(e.clientX - rect.left);
    const y = Math.floor(e.clientY - rect.top);
    if (drawingLine) {
        if (!lineStart) {
            lineStart = {x, y};
        } else {
            elements.push(new LineElement(lineStart.x, lineStart.y, x, y, parseInt(lineWidth.value)));
            drawingLine = false;
            lineBtn.textContent = 'Draw Line';
            lineStart = null;
            draw();
        }
    } else {
        const text = prompt('Enter text');
        if (text) {
            elements.push(new TextElement(text, x, y));
            draw();
        }
    }
});

canvas.addEventListener('mousemove', e => {
    const rect = canvas.getBoundingClientRect();
    const x = Math.floor(e.clientX - rect.left);
    const y = Math.floor(e.clientY - rect.top);
    cursorPos.textContent = `${x}, ${y}`;
});

bgToggle.addEventListener('change', setBackground);
gridToggle.addEventListener('change', drawGrid);
lineWidth.addEventListener('input', draw);

setBackground();
drawGrid();
