# Contributing to Task Management System

Thank you for considering contributing to the Task Management System! This document provides guidelines and instructions for contributing.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/Task-Management-System.git
   cd Task-Management-System
   ```
3. **Install dependencies**:
   ```bash
   npm install
   ```
4. **Set up environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your local MongoDB URI
   ```
5. **Start development server**:
   ```bash
   npm run dev
   ```

## 🔧 Development Workflow

1. **Create a new branch** for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bugfix-name
   ```

2. **Make your changes** following the code style guidelines

3. **Test your changes** thoroughly

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Description of changes"
   ```

5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request** on GitHub

## 📝 Code Style Guidelines

### JavaScript/Node.js
- Use ES6+ syntax where appropriate
- Use `const` and `let` instead of `var`
- Use arrow functions for callbacks
- Keep functions small and focused
- Add comments for complex logic
- Follow existing code patterns

### Models
- Define clear schema with proper validation
- Add indexes for frequently queried fields
- Include helpful comments
- Use proper data types

### Controllers
- Keep controllers thin - move business logic to services if needed
- Always handle errors properly
- Return consistent response formats
- Use async/await for promises

### Routes
- Use RESTful conventions
- Apply appropriate middleware (auth, validation)
- Group related routes together

## 🧪 Testing

Before submitting a PR:
1. Test all API endpoints manually
2. Ensure no existing functionality is broken
3. Test edge cases
4. Verify error handling

## 📚 Documentation

When adding new features:
- Update API_DOCUMENTATION.md with new endpoints
- Update README.md if necessary
- Add inline code comments
- Update Postman collection if applicable

## 🐛 Bug Reports

When reporting bugs, please include:
- Description of the issue
- Steps to reproduce
- Expected behavior
- Actual behavior
- Environment details (Node version, OS, etc.)
- Error messages or logs

## 💡 Feature Requests

When suggesting features:
- Clear description of the feature
- Use cases and benefits
- Possible implementation approach
- Any UI/UX considerations

## 🔐 Security

If you discover a security vulnerability:
- **DO NOT** open a public issue
- Email details to the repository maintainers
- Wait for acknowledgment before disclosing

## ✅ Pull Request Checklist

Before submitting a PR, ensure:
- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] Commit messages are clear and descriptive
- [ ] No unnecessary files are included
- [ ] Changes are tested locally

## 📋 Commit Message Format

Use clear, descriptive commit messages:

```
Add feature: Brief description

Detailed explanation of what and why.
```

Examples:
- `Add: User avatar upload functionality`
- `Fix: Task status update not sending notifications`
- `Update: Improve performance of task filtering`
- `Docs: Add API examples for comments endpoint`

## 🎯 Areas for Contribution

We welcome contributions in:

- **Backend Features**: New endpoints, business logic improvements
- **Performance**: Database query optimization, caching
- **Security**: Security enhancements, vulnerability fixes
- **Documentation**: API docs, examples, tutorials
- **Testing**: Unit tests, integration tests
- **Bug Fixes**: Any bug fixes are appreciated!
- **Code Quality**: Refactoring, best practices

## 🤝 Community Guidelines

- Be respectful and inclusive
- Welcome newcomers
- Provide constructive feedback
- Help others learn and grow
- Follow the code of conduct

## 📞 Questions?

If you have questions about contributing:
- Open a GitHub issue with the "question" label
- Check existing documentation
- Review closed PRs for examples

Thank you for contributing to make this project better! 🎉
