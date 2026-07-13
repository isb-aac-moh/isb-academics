-- Real 2026-27 Mohali course catalog, extracted from:
--   "Concentration and Industry Specialisation - 2026-27" (authoritative area mapping)
--   "Lineup_Mohali_2026-27_Core and Elective" (terms, flexi-core, dates)
-- Replaces the earlier [PLACEHOLDER] rows entirely.
--
-- Tag key — Concentrations: ENTR, FINC, MKTG, OPMT, INTM, STLD
--           Industry specializations: HCMG (Healthcare), MANF (Manufacturing), PBPL (Public Policy), INFR (Infrastructure)
-- Credits are 1 unless noted (DTME1/DTME2 are the two 1-credit halves of the 2-credit DTME sequence).

delete from public.courses where name like '[PLACEHOLDER]%';

alter table public.courses add constraint courses_code_unique unique (code);

-- helper: split area tags into concentration_areas[] vs industry_specializations[] at insert time is manual below.
-- CONC = Entrepreneurship | Finance | Marketing | Operations Management | Information Technology Management | Strategy and Leadership
-- SPEC = Healthcare | Manufacturing | Public Policy | Infrastructure

insert into public.courses (code, name, professor, term, credits, concentration_areas, industry_specializations) values
-- Entrepreneurship area
('PRCG', 'Pricing', 'Abhinav Uppal', 'Term 4', 1, array['Marketing','Entrepreneurship'], array[]::text[]),
('ENTR', 'Entrepreneurship (mandatory for ENTR concentration)', 'Ramakrishna S Velamuri', 'Term 4', 1, array['Entrepreneurship'], array[]::text[]),
('MGSP', 'Managing Strategic Partnerships', 'TBD', 'Term 4', 1, array['Strategy and Leadership','Entrepreneurship'], array[]::text[]),
('BVFS', 'Business Valuation Using Financial Statements', 'Rishabh Aggarwal', 'Term 5', 1, array['Finance','Entrepreneurship'], array[]::text[]),
('NEGA1', 'Negotiation Analysis', 'Ashneet Kaur', 'Term 5', 1, array['Strategy and Leadership','Entrepreneurship'], array['Public Policy','Infrastructure']),
('ENVC', 'Entrepreneurship and Venture Capital', 'Ramakrishna S Velamuri', 'Term 5', 1, array['Entrepreneurship','Finance','Strategy and Leadership'], array['Healthcare']),
('NSDL', 'New Product and Service Development and Launch', 'Siddharth S Singh', 'Term 5', 1, array['Marketing','Entrepreneurship'], array[]::text[]),
('CEOP', 'CEO Perspectives', 'TBD', 'Term 6', 1, array['Marketing','Entrepreneurship'], array[]::text[]),
('BLAW', 'Business Law', 'TBD', 'Term 6', 1, array['Entrepreneurship','Strategy and Leadership'], array[]::text[]),
('NEGA2', 'Negotiation Analysis', 'Abhishek Gupte', 'Term 6', 1, array['Strategy and Leadership','Entrepreneurship'], array['Public Policy','Infrastructure']),
('SIMT', 'Strategic Innovation Management', 'TBD', 'Term 6', 1, array['Strategy and Leadership','Entrepreneurship','Information Technology Management'], array[]::text[]),
('COEN', 'Corporate Entrepreneurship', 'TBD', 'Term 6', 1, array['Strategy and Leadership','Entrepreneurship'], array[]::text[]),
('TFTM', 'The Founder''s Toolkit: Managing Mission, Morals, Mindsets & Motivation', 'TBD', 'Block Week 4', 1, array['Strategy and Leadership','Entrepreneurship'], array[]::text[]),
('SGFG', 'Strategies for Growth', 'TBD', 'Term 7', 1, array['Strategy and Leadership','Entrepreneurship'], array['Healthcare']),
('FINB', 'Financial Services for the Next Billion', 'TBD', 'Term 6', 1, array['Finance','Entrepreneurship'], array['Public Policy']),
('PEVF', 'Private Equity and Venture Capital Financing', 'TBD', 'Term 5', 1, array['Finance','Entrepreneurship','Strategy and Leadership'], array['Healthcare','Public Policy']),
('DMKT', 'Designing Markets', 'TBD', 'Term 6', 1, array['Entrepreneurship','Strategy and Leadership'], array['Public Policy']),
('HCEN', 'Health Care Entrepreneurship', 'Santosh P. N. / Deepthi Nemani', 'Block Week 1', 1, array['Entrepreneurship'], array['Healthcare']),

-- Finance area (additions)
('NMEU2', 'Navigating Macro-economic Uncertainty (Flexi Core)', 'Shiv Dixit', 'Term 2', 1, array['Finance'], array['Public Policy']),
('BACF2', 'Business Analytics for Corporate Finance (Flexi Core)', 'Peeyush Taori', 'Term 3', 1, array['Finance'], array[]::text[]),
('FRDI', 'Fraud Detection and Investigation', 'Chetan Dalal', 'Block Week 2', 1, array['Finance'], array[]::text[]),
('FSAN', 'Financial Statement Analysis', 'Gurvinder Sandhu', 'Term 4', 1, array['Finance'], array[]::text[]),
('TAAM', 'Transaction Analysis and Modeling', 'TBD', 'Term 6', 1, array['Finance'], array['Infrastructure']),
('TATU', 'Transaction Analysis and Modeling (TURBO)', 'TBD', 'Term 6', 1, array['Finance'], array[]::text[]),
('AFMP', 'Applied Financial Modeling for Private Equity', 'TBD', 'Block Week 3', 1, array['Finance'], array['Healthcare']),
('BAAF', 'Business Applications Of AI In Finance', 'TBD', 'Block Week 4', 1, array['Finance','Information Technology Management'], array[]::text[]),
('SPMG', 'Strategic Performance Management', 'N. V. Ramanan', 'Term 7', 1, array['Finance','Strategy and Leadership','Operations Management'], array['Manufacturing','Healthcare']),
('DAFN', 'Data Analytics in Finance', 'TBD', 'Term 6', 1, array['Finance'], array[]::text[]),
('IDTF', 'Intro to FinTech: Innovations and Disruptions to Traditional Finance', 'TBD', 'Term 6', 1, array['Finance','Information Technology Management'], array[]::text[]),
('RDFV', 'Real Estate Development and Financing of Ventures', 'TBD', 'Term 6', 1, array['Finance'], array['Infrastructure']),
('INEC', 'Information Economics', 'Anshuman Bhakri', 'Term 4', 1, array['Finance','Information Technology Management'], array['Public Policy']),
('INVT', 'Investments', 'Anindo Sarkar', 'Term 4', 1, array['Finance'], array[]::text[]),
('OPFR', 'Options and Futures', 'Jan Keil', 'Term 4', 1, array['Finance'], array[]::text[]),
('CCMA', 'Corporate Control, Mergers and Acquisitions', 'Vasudha Nukala', 'Term 4', 1, array['Finance'], array[]::text[]),
('IBCM', 'Investment Banking and Capital Markets (Study Trek)', 'Krishnamurthy Vaidyanathan', 'Block Week 3', 1, array['Finance'], array[]::text[]),
('FTNA', 'Financing the Nation', 'Shiv Dixit', 'Term 7', 1, array['Finance'], array['Public Policy']),
('ACFN', 'Advanced Corporate Finance', 'TBD', 'Term 7', 1, array['Finance'], array[]::text[]),
('INFS', 'Indian Financial Systems', 'TBD', 'Term 7', 1, array['Finance'], array['Public Policy']),
('RIMG', 'Risk Management', 'TBD', 'Term 7', 1, array['Finance'], array[]::text[]),
('GIFT', 'Gateway to International Finance Trek (Study Trek)', 'TBD', 'Block Week 3', 1, array['Finance'], array[]::text[]),
('PFCA', 'The Practice of Finance with Claude AI', 'Bhagwan Chowdhry / Padmanabhan Balasubramanian', 'Block Week 1', 1, array['Finance'], array[]::text[]),
('STAR', 'Strategic Trading and Research', 'TBD', 'Term 5', 1, array['Finance'], array[]::text[]),
('SMTD', 'Security Markets and Trading', 'Ramabhadran Thirumalai', 'Term 5', 1, array['Finance'], array[]::text[]),

-- Healthcare specialization (additions)
('CMGT', 'Change Management', 'TBD', 'Term 4', 1, array['Strategy and Leadership'], array['Public Policy','Healthcare']),
('BPEX', 'Business Process Excellence', 'TBD', 'Term 5', 1, array['Operations Management','Strategy and Leadership'], array['Manufacturing','Healthcare']),
('MSDW', 'Managing Services in a Digital World', 'Sandeep Rath', 'Term 6', 1, array['Operations Management'], array['Manufacturing','Healthcare']),
('MKSV', 'Marketing Services', 'TBD', 'Term 6', 1, array['Marketing'], array['Healthcare']),
('DTIS', 'Digital Transformation in Services (Study Trek)', 'Prof Vijaya Sunder M', 'Block Week 3', 1, array['Operations Management','Strategy and Leadership','Information Technology Management'], array['Healthcare']),
('MSBD', 'Managing Sales for Business Development', 'TBD', 'Term 7', 1, array['Marketing'], array['Healthcare']),
('MSBP', 'Marketing Strategies at the Bottom of the Pyramid to Deliver Impact and Profit', 'Harish Bijoor', 'Block Week 4', 1, array['Marketing'], array['Healthcare']),

-- Information Technology Management area (additions)
('FRNT3', 'Frontier Technologies (Sections G,H,I) (Flexi Core)', 'Vishal Karungulam', 'Term 2', 1, array['Information Technology Management'], array[]::text[]),
('FRNT4', 'Frontier Technologies (Sections J,K,L) (Flexi Core)', 'Jui Ramaprasad / Subodha Kumar', 'Term 2', 1, array['Information Technology Management'], array[]::text[]),
('PADM2', 'Prescriptive Analytics for Business Decision Making (Flexi Core)', 'Sriram Sankaranarayanan', 'Term 3', 1, array['Information Technology Management','Operations Management'], array[]::text[]),
('TISE', 'Technologies in Sports Economy', 'Zafar Hussain / A R Srikkanth', 'Block Week 1', 1, array['Information Technology Management'], array[]::text[]),
('DTME1', 'Digital Transformation and Innovation in the Manufacturing Ecosystem (Credit 1 of 2 — mandatory for Manufacturing specialization)', 'TBD', 'Term 5', 1, array['Operations Management','Information Technology Management'], array['Manufacturing']),
('DTME2', 'Digital Transformation and Innovation in the Manufacturing Ecosystem (Credit 2 of 2 — mandatory for Manufacturing specialization)', 'TBD', 'Term 7', 1, array['Operations Management','Information Technology Management'], array['Manufacturing']),
('PMGT', 'Project Management', 'TBD', 'Term 6', 1, array['Operations Management','Information Technology Management'], array['Manufacturing','Public Policy','Infrastructure']),
('PRRA', 'Revenue Management', 'TBD', 'Term 7', 1, array['Information Technology Management','Operations Management'], array['Infrastructure','Manufacturing']),
('SEED', 'Sustainable Empowerment through Emerging Digitization (Study Trek)', 'Ashwini Chhatre / Sabareesh Ramachandran / Debolina Dutta', 'Block Week 2', 1, array['Information Technology Management'], array['Public Policy']),
('GENAI', 'Generative AI - A New Paradigm (GenAI 101)', 'Sumeet Kumar', 'Term 4', 1, array['Information Technology Management'], array['Infrastructure','Manufacturing']),
('SWPM', 'Software Product Management', 'TBD', 'Term 4', 1, array['Information Technology Management'], array[]::text[]),
('MTCC', 'Monetizing Tech: From Code to Cashflow', 'Rajib Saha', 'Term 5', 1, array['Information Technology Management'], array[]::text[]),
('ABTE', 'A/B Testing and Tech Product Experimentation', 'TBD', 'Term 5', 1, array['Information Technology Management'], array[]::text[]),
('ARDA', 'Architecting Digital Advantage', 'TBD', 'Term 6', 1, array['Information Technology Management'], array[]::text[]),
('TSFL', 'Tech Startup Failures', 'Vishal Karungulam', 'Term 6', 1, array['Information Technology Management'], array[]::text[]),
('DTSP', 'Deconstructing Tech Startup Pivots (Study Trek)', 'Vishal Karungulam', 'Block Week 3', 1, array['Information Technology Management'], array[]::text[]),
('GRIT', 'Global Resilience with Integrated Technologies (Study Trek)', 'Vishal Karungulam', 'Block Week 4', 1, array['Information Technology Management'], array[]::text[]),
('DNST', 'Data Narratives and Storytelling', 'TBD', 'Term 7', 1, array['Information Technology Management'], array[]::text[]),
('LSWS', 'Launching Software Startups', 'TBD', 'Term 7', 1, array['Information Technology Management'], array[]::text[]),

-- Manufacturing specialization (additions)
('LSCM', 'Supply Chain Management A: Demand Fulfillment', 'Vishwakant Malladi / Subodha Kumar', 'Term 4', 1, array['Operations Management'], array['Manufacturing']),
('LOES', 'Leveraging Operations for Environmental and Social Sustainability', 'TBD', 'Term 5', 1, array['Operations Management'], array['Manufacturing','Public Policy']),
('OSTR', 'Operations Strategy', 'TBD', 'Term 7', 1, array['Operations Management','Strategy and Leadership'], array['Manufacturing']),
('LSCMB', 'Supply Chain Management B: Supplier Network Design and Risk Management', 'TBD', 'Term 7', 1, array['Operations Management'], array['Manufacturing','Public Policy']),
('SGSC', 'Strategic Sourcing', 'Sriram Sankaranarayanan', 'Term 7', 1, array['Operations Management'], array['Manufacturing','Public Policy']),

-- Marketing area (additions)
('BANM2', 'Business Analytics for Marketing and Growth (Flexi Core)', 'Venkata Dakshinamurthy / Anand V Bodapati', 'Term 3', 1, array['Marketing'], array[]::text[]),
('ASMD2', 'The Art and Science of Managerial Decision-Making (Flexi Core)', 'Pranav Jindal', 'Term 3', 1, array['Marketing','Strategy and Leadership'], array[]::text[]),
('MPAI', 'Market Positioning and Adoption Challenges of AI Start-Ups (Study Trek)', 'Avik Sarkar', 'Block Week 2', 1, array['Marketing'], array[]::text[]),
('IESB', 'Impact Imperative: Embedding Society in Business', 'Rathish Balakrishnan', 'Block Week 2', 1, array['Marketing'], array[]::text[]),
('MSTK', 'Marketing Strategy Study Trek', 'Raghuram Bommaraju', 'Block Week 4', 1, array['Marketing'], array[]::text[]),
('AIMO', 'AI-First Marketing Organisation', 'Shailesh Kumar', 'Block Week 2', 1, array['Marketing'], array[]::text[]),
('GPMK', 'Growth and Performance Marketing', 'Siddharth Prusty', 'Term 4', 1, array['Marketing'], array[]::text[]),
('MKTR', 'Marketing Research for Consumer Insights and Growth Strategies', 'TBD', 'Term 4', 1, array['Marketing'], array[]::text[]),
('CAMS', 'Creating Market Access: Managing Channel Strategy', 'Madhu Viswanathan', 'Term 4', 1, array['Marketing'], array[]::text[]),
('RTLG', 'Retailing', 'TBD', 'Term 5', 1, array['Marketing'], array[]::text[]),
('COBE', 'Consumer Behaviour', 'Poornima Vinoo', 'Term 5', 1, array['Marketing'], array[]::text[]),
('AMCS', 'Advertising and Marketing Communication Strategy', 'TBD', 'Term 6', 1, array['Marketing'], array[]::text[]),
('RMPL', 'Rural Marketing Playbook for Beyond City Limits', 'TBD', 'Term 6', 1, array['Marketing'], array[]::text[]),
('CERP', 'Customer Engagement through Reward Programs', 'Rohan Bhalla', 'Block Week 1', 1, array['Marketing'], array[]::text[]),
('MPSB', 'MarTech Playbook for Storytelling and Branding', 'Andre Bonfrer', 'Block Week 1', 1, array['Marketing'], array[]::text[]),
('BRMT', 'Brand Management', 'TBD', 'Term 7', 1, array['Marketing'], array[]::text[]),
('BBML', 'Business to Business Marketing', 'TBD', 'Term 7', 1, array['Marketing'], array[]::text[]),
('CTFI', 'Contemporary Film Industry', 'TBD', 'Term 7', 1, array['Marketing'], array[]::text[]),
('MHPI', 'Marketing of High-Technology Products and Innovations', 'TBD', 'Term 7', 1, array['Marketing'], array[]::text[]),
('SCAT', 'Strategic Customer Analytics or B2B Marketing', 'TBD', 'Term 7', 1, array['Marketing'], array[]::text[]),
('DPI2', 'DPI 2.0: Marketing of Innovation at Scale', 'Prakash Bagri', 'Block Week 2', 1, array['Marketing'], array[]::text[]),
('MLAI', 'Managing Growth: Marketing Leadership with AI', 'Adarsh Sreekumar Nair', 'Block Week 3', 1, array['Marketing'], array[]::text[]),
('MSDG', 'Marketing Strategy Simulation: Decision Making for Growth', 'Raghuram Bommaraju', 'Block Week 1', 1, array['Marketing'], array[]::text[]),

-- Operations Management area (additions)
('DTSC', 'Digital Technologies in Supply Chains (Study Trek)', 'Nitish Jain', 'Block Week 2', 1, array['Operations Management'], array[]::text[]),
('SOMS', 'Strategy and Operations Management Simulation', 'Himanshu Tambe', 'Block Week 4', 1, array['Operations Management','Strategy and Leadership'], array[]::text[]),

-- Public Policy specialization (additions)
('BSNS2', 'Business, Society and Non-Market Strategies (Flexi Core)', 'Ashwini Chhatre / Pankaj Kumar', 'Term 2', 1, array['Strategy and Leadership'], array['Public Policy']),
('DIPP', 'Driving Impactful Public Policy: Insights from the Frontline', 'TBD', 'Block Week 2', 1, array[]::text[], array['Public Policy']),
('MCAP', 'Market Competition and Antitrust Policy', 'TBD', 'Term 6', 1, array['Strategy and Leadership'], array['Public Policy']),
('MCIS', 'Managing Complex Organizations: Lessons from the Indian State', 'TBD', 'Block Week 3', 1, array[]::text[], array['Public Policy']),
('GEBU', 'Geopolitics and Business', 'Deepa Mani', 'Block Week 2', 1, array[]::text[], array['Public Policy']),

-- Strategy and Leadership area (additions)
('MADM2', 'Managerial Accounting in Decision Making (Flexi Core)', 'Radhika Lunawat / Sunil Dutta', 'Term 3', 1, array['Strategy and Leadership'], array[]::text[]),
('LGTM', 'Leading Teams', 'Shad Morris', 'Block Week 1', 1, array['Strategy and Leadership'], array[]::text[]),
('LDEL', 'Life Design Lab', 'Navyug Mohnot', 'Block Week 2', 1, array['Strategy and Leadership'], array[]::text[]),
('MTOG', 'Managing Talent & Organizational Growth (Study Trek)', 'Chandrasekhar Sripada', 'Block Week 1', 1, array['Strategy and Leadership'], array[]::text[]),
('LPFW', 'Leading People through the Future of Work', 'Chandrasekhar Sripada', 'Term 4', 1, array['Strategy and Leadership'], array[]::text[]),
('GSMT', 'Global Strategic Management', 'TBD', 'Term 4', 1, array['Strategy and Leadership'], array[]::text[]),
('LWPM', 'Leading with Purpose and Meaning', 'TBD', 'Term 5', 1, array['Strategy and Leadership'], array[]::text[]),
('CDMA2', 'Corporate Development: Mergers & Acquisitions', 'TBD', 'Term 5', 1, array['Strategy and Leadership'], array[]::text[]),
('MSTC', 'The Modern Strategy Consultant', 'TBD', 'Term 5', 1, array['Strategy and Leadership'], array[]::text[]),
('STRI', 'Strategy Implementation', 'TBD', 'Term 6', 1, array['Strategy and Leadership'], array[]::text[]),
('AIRG', 'Artificial Intelligence in Organizations', 'Arvind Karunakaran', 'Block Week 3', 1, array['Strategy and Leadership'], array[]::text[]),
('STGB', 'Strategy and Governance in Business Groups', 'TBD', 'Block Week 3', 1, array['Strategy and Leadership'], array[]::text[]),
('SDLD', 'Self-Discovery and Leadership', 'TBD', 'Block Week 4', 1, array['Strategy and Leadership'], array[]::text[]),
('PWPT', 'Power and Politics', 'TBD', 'Term 7', 1, array['Strategy and Leadership'], array[]::text[]),
('CSOD', 'Corporate Strategy and Organization Design', 'TBD', 'Term 7', 1, array['Strategy and Leadership'], array[]::text[]),
('ECSG', 'Economics of Strategy', 'TBD', 'Term 7', 1, array['Strategy and Leadership'], array[]::text[]),
('OTTL', 'OTT & Learn: Leadership Lessons from Movies', 'TBD', 'Term 7', 1, array['Strategy and Leadership'], array[]::text[])

on conflict (code) do update set
  name = excluded.name,
  professor = excluded.professor,
  term = excluded.term,
  concentration_areas = excluded.concentration_areas,
  industry_specializations = excluded.industry_specializations;
