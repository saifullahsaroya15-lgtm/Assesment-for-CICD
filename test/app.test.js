const request = require('supertest');
const app = require('../app');

describe('GET /', () => {
    it('responds with json message', async () => {
        const res = await request(app).get('/');
        expect(res.statusCode).toBe(200);
        expect(res.body.message).toContain('DevOps Candidate');
    });
});

describe('GET /health', () => {
    it('responds with healthy status', async () => {
        const res = await request(app).get('/health');
        expect(res.statusCode).toBe(200);
        expect(res.body.status).toBe('healthy');
    });
});
