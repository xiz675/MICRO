SELECT f2.name, f0.name, e0.related_work_id, e0.work_id, f1.name
FROM uspto.publication_cited_by_patent work0, uspto.publication_cited_by_patent work1, uspto.institution2 institution0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_institution2 f2, openalex_subset_works_institution e1
WHERE f0.name = work1.name and f2.ror = institution0.ror and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.institution_id;
SELECT en1.name, e0.work_id, f1.name, en2.name, en0.name, f0.name
FROM uspto.subfield_patent subfield0, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, openalex_subset_field_domain e3, field en0, subfield en1, domain en2
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and e2.field_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id and en2.id=e3.domain_id;
SELECT f2.cited_by_count, f2.name, f1.name, f0.name
FROM uspto.topic_patent topic1, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_topic1 f2, openalex_subset_topics_topics e1
WHERE e1.sibling_id = topic0.id and f0.name = work0.name and e0.topic_id = topic1.id and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.sibling_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent1 work0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_work3 f1, openalex_subset_works_topics_final e1, keyword en0
WHERE e0.id = topic0.id and f1.name = work0.name and e0.id=e1.topic_id and f0.id=e0.id and f1.id=e1.work_id and en0.name=e0.word;
SELECT e0.work_id, f1.name, en0.name, en1.name, f0.name, e0.work_id
FROM uspto.topic_patent1 topic0, uspto.field_patent2 field0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en1.name, en2.name, en0.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent2 topic0, uspto.field_patent1 field0, filter_topic1 f0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, subfield en1, domain en2
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and f0.id=e0.id and en0.id=e1.field_id and en1.id=e0.subfield_id and en2.id=e2.domain_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.field_patent2 field0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e2.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en3.name, en0.name, en1.name, en2.name
FROM uspto.topic_patent topic0, uspto.field_patent1 field0, uspto.subfield_patent subfield0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, topic en2, subfield en3
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e0.id and en3.id=e1.subfield_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent2 work1, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT en1.name, f0.name, f2.name, en0.name, f1.name, e0.work_id
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent1 topic0, uspto.field_patent2 field0, uspto.subfield_patent2 subfield0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, openalex_subset_subfield_field e3, field en0, subfield en1
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and e3.field_id = field0.id and e0.work_id=e1.work_id and e1.topic_id=e2.id and e2.subfield_id=e3.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e3.field_id and en1.id=e2.subfield_id;
SELECT en0.name, en3.name, e0.id, e1.subfield_id, en2.name, en1.name, e2.field_id
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent2 topic0, uspto.field_patent2 field0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, topic en2, subfield en3
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e0.id and en3.id=e1.subfield_id;
SELECT f0.name, e0.related_work_id, e1.related_work_id, e0.work_id, f2.name, f1.name
FROM uspto.publication_cited_by_patent work2, uspto.publication_cited_by_patent work1, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_work3 f2, openalex_subset_works_related_works e1
WHERE f0.name = work2.name and f2.name = work0.name and f1.name = work1.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.related_work_id;
SELECT f1.name, en0.name, en1.name, f0.name, e2.field_id
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent2 topic0, uspto.field_patent2 field0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_keywords_topics e1, keyword en0
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.name=e1.word;
SELECT en2.name, en1.name, en0.name
FROM uspto.topic_patent1 topic0, uspto.field_patent1 field0, uspto.subfield_patent subfield0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, subfield en0, topic en1, field en2
WHERE e1.field_id = field0.id and e0.id = topic0.id and e0.subfield_id = subfield0.id and e0.subfield_id=e1.id and en0.id=e0.subfield_id and en1.id=e0.id and en2.id=e1.field_id;
SELECT f2.name, f3.name, f0.name, f1.name
FROM uspto.publication_cited_by_patent1 work1, uspto.inventors1 author0, uspto.publication_cited_by_patent2 work0, uspto.institution1 institution0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_institution2 f3, openalex_subset_works_institution e2
WHERE f1.name = work0.name and f3.ror = institution0.ror and f2.name = work1.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.institution_id;
SELECT en1.name, f0.name, en2.name, en0.name, f0.cited_by_count
FROM uspto.topic_patent topic0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, filter_topic1 f0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, subfield en1, domain en2
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and f0.id=e0.id and en0.id=e1.field_id and en1.id=e0.subfield_id and en2.id=e2.domain_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent work1, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT f0.name, en0.name, f1.name, f2.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent2 work0, uspto.topic_patent2 topic1, uspto.subfield_patent1 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, filter_topic1 f2, openalex_subset_topics_subfield e2, subfield en0
WHERE e2.id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id = topic1.id and e0.topic_id=e1.id and e1.subfield_id=e2.subfield_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e2.id and en0.id=e1.subfield_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.inventors1 author0, uspto.publication_cited_by_patent2 work1, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT f2.name, f0.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, uspto.topic_patent topic1, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.id=e1.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id;
SELECT f0.name, en0.name, f1.name, f2.name
FROM uspto.publication_cited_by_patent1 work1, uspto.topic_patent2 topic0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_keywords_topics e2, keyword en0
WHERE e1.topic_id = topic0.id and f0.name = work1.name and f1.name = work0.name and e0.related_work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.topic_id and en0.name=e2.word;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.topic_patent1 topic0, uspto.publication_cited_by_patent work0, uspto.subfield_patent2 subfield0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en0.name, f1.name, en1.name, f0.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, uspto.field_patent field0, uspto.subfield_patent2 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en0.name, f1.name, e0.work_id, f0.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_keywords_topics e1, keyword en0
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.name=e1.word;
SELECT f1.name, f3.name, f0.name, f2.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.topic_patent1 topic1, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1, filter_author2 f3, openalex_subset_works_author e2
WHERE e0.id = topic0.id and e0.sibling_id = topic1.id and f3.name = author0.name and f2.name = work0.name and e0.sibling_id=e1.topic_id and e1.work_id=e2.work_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id and f3.id=e2.author_id;
SELECT f1.name, f0.name, en0.name
FROM uspto.topic_patent2 topic0, uspto.topic_patent topic1, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, openalex_subset_keywords_topics e1, keyword en0
WHERE e0.id = topic1.id and e0.sibling_id = topic0.id and e0.sibling_id=e1.id and f0.id=e0.id and f1.id=e0.sibling_id and en0.name=e1.word;
SELECT en0.name, f0.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.topic_patent2 topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent work0, uspto.subfield_patent subfield0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en0.name, f1.name, e0.work_id, f0.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_keywords_topics e1, keyword en0
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.name=e1.word;
SELECT f2.name, f3.name, f0.name, f1.name
FROM uspto.institution1 institution1, uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, uspto.institution1 institution0, filter_topic1 f0, filter_work3 f1, openalex_subset_works_topics_final e0, filter_institution2 f2, openalex_subset_works_institution e1, filter_institution2 f3, institutions_child_of_institutions e2
WHERE e0.topic_id = topic0.id and f1.name = work0.name and f2.ror = institution0.ror and f3.ror = institution1.ror and e0.work_id=e1.work_id and e1.institution_id=e2.institution_id and f0.id=e0.topic_id and f1.id=e0.work_id and f2.id=e1.institution_id and f3.id=e2.associated_institution_id;
SELECT en1.name, e2.work_id, f0.name, en0.name, f1.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, uspto.field_patent field0, uspto.subfield_patent2 subfield0, openalex_subset_subfield_field e0, filter_topic1 f0, openalex_subset_topics_subfield e1, filter_work3 f1, openalex_subset_works_topics_final e2, field en0, subfield en1
WHERE e0.field_id = field0.id and e1.id = topic0.id and f1.name = work0.name and e0.id = subfield0.id and e0.id=e1.subfield_id and e1.id=e2.topic_id and f0.id=e1.id and f1.id=e2.work_id and en0.id=e0.field_id and en1.id=e0.id;
SELECT en0.name, f3.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent topic1, uspto.topic_patent1 topic0, uspto.subfield_patent2 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, filter_topic1 f2, openalex_subset_topics_subfield e2, filter_work3 f3, openalex_subset_works_topics_final e3, subfield en0
WHERE e2.id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id = topic1.id and e0.topic_id=e1.id and e1.subfield_id=e2.subfield_id and e2.id=e3.topic_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e2.id and f3.id=e3.work_id and en0.id=e1.subfield_id;
SELECT f1.name, f2.name, f0.name
FROM uspto.publication_cited_by_patent2 work0, uspto.institution2 institution0, uspto.institution institution1, filter_work3 f0, filter_institution2 f1, openalex_subset_works_institution e0, filter_institution2 f2, institutions_child_of_institutions e1
WHERE f0.name = work0.name and f2.ror = institution0.ror and f1.ror = institution1.ror and e0.institution_id=e1.institution_id and f0.id=e0.work_id and f1.id=e0.institution_id and f2.id=e1.associated_institution_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_keywords_topics e1, keyword en0
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.name=e1.word;
SELECT e1.work_id, en0.name, f0.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_work3 f1, openalex_subset_works_topics_final e1, keyword en0
WHERE e0.id = topic0.id and f1.name = work0.name and e0.id=e1.topic_id and f0.id=e0.id and f1.id=e1.work_id and en0.name=e0.word;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.field_patent field0, uspto.subfield_patent2 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id = topic0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT f0.name, f2.name, f1.name
FROM uspto.topic_patent1 topic0, uspto.inventors1 author0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.publication_cited_by_patent1 work1, uspto.inventors1 author0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT en1.name, en0.name, f0.name
FROM uspto.topic_patent2 topic0, uspto.subfield_patent subfield0, uspto.field_patent field0, filter_topic1 f0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, field en0, subfield en1
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and f0.id=e0.id and en0.id=e1.field_id and en1.id=e0.subfield_id;
SELECT f2.cited_by_count, f2.name, f1.name, f0.name
FROM uspto.inventors1 author0, uspto.publication_cited_by_patent work0, uspto.publication_cited_by_patent work1, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_author e1
WHERE f2.name = work0.name and f1.name = author0.name and f0.name = work1.name and e0.author_id=e1.author_id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.work_id;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.topic_patent1 topic0, uspto.inventors2 author0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_keywords_topics e2, keyword en0
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.name=e2.word;
SELECT f3.name, f2.name, f1.name, f0.name
FROM uspto.inventors author0, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, uspto.publication_cited_by_patent work1, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_topic1 f2, openalex_subset_works_topics_final e1, filter_author2 f3, openalex_subset_works_author e2
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = work1.name and f3.name = author0.name and e0.related_work_id=e1.work_id and e0.related_work_id=e2.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.topic_id and f3.id=e2.author_id;
SELECT e0.work_id, f1.name, en0.name, en1.name, f0.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, uspto.field_patent2 field0, uspto.subfield_patent1 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e1.subfield_id = subfield0.id and e2.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT f1.name, f0.name, f3.name, f2.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent topic0, uspto.inventors1 author0, uspto.publication_cited_by_patent work1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_topic1 f3, openalex_subset_works_topics_final e2
WHERE e2.topic_id = topic0.id and f0.name = author0.name and f1.name = work1.name and f2.name = work0.name and e0.work_id=e1.related_work_id and e1.work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.work_id and f3.id=e2.topic_id;
SELECT en0.name, f0.name, f2.name, f1.cited_by_count, f0.cited_by_count, f1.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent2 topic0, uspto.subfield_patent2 subfield0, uspto.publication_cited_by_patent work1, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and f0.name = work0.name and e2.subfield_id = subfield0.id and f1.name = work1.name and e0.related_work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT f1.name, f0.name, e1.work_id, f2.name
FROM uspto.topic_patent2 topic0, uspto.topic_patent topic1, uspto.publication_cited_by_patent2 work0, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.sibling_id=e1.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent2 topic0, uspto.topic_patent1 topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT en0.name, f0.name, f2.name, f1.name, e0.author_id
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en0.name, f1.name, f2.name, f0.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent2 topic0, uspto.subfield_patent1 subfield0, uspto.publication_cited_by_patent work1, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and f0.name = work1.name and e0.related_work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT f1.name, f2.name, f0.name
FROM uspto.institution institution0, uspto.institution institution1, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_institution2 f1, openalex_subset_works_institution e0, filter_institution2 f2, institutions_child_of_institutions e1
WHERE f0.name = work0.name and f2.ror = institution0.ror and f1.ror = institution1.ror and e0.institution_id=e1.institution_id and f0.id=e0.work_id and f1.id=e0.institution_id and f2.id=e1.associated_institution_id;
SELECT f2.works_count, f0.name, f2.name, f1.name
FROM uspto.inventors author0, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT f2.name, f3.name, f1.name, f0.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent work0, uspto.topic_patent topic0, uspto.publication_cited_by_patent work1, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_work3 f2, openalex_subset_works_topics_final e1, filter_author2 f3, openalex_subset_works_author e2
WHERE e0.topic_id = topic0.id and f0.name = work0.name and f3.name = author0.name and f2.name = work1.name and e0.topic_id=e1.topic_id and e1.work_id=e2.work_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.work_id and f3.id=e2.author_id;
SELECT en3.name, en0.name, en1.name, en2.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent topic0, uspto.field_patent field0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, topic en2, subfield en3
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e0.id and en3.id=e1.subfield_id;
SELECT f0.name, en1.name, f1.name, f3.name, en2.name, en0.name
FROM uspto.field_patent field1, uspto.field_patent2 field0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, openalex_subset_subfield_field e3, openalex_subset_field_domain e4, filter_work3 f3, openalex_subset_works_author e5, filter_topic1 f4, openalex_subset_works_topics_final e6, openalex_subset_topics_subfield e7, openalex_subset_subfield_field e8, openalex_subset_field_domain e9, field en0, field en1, domain en2
WHERE e8.field_id = field1.id and e3.field_id = field0.id and f3.name = work0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and e2.subfield_id=e3.id and e3.field_id=e4.id and e0.author_id=e5.author_id and e5.work_id=e6.work_id and e6.topic_id=e7.id and e7.subfield_id=e8.id and e8.field_id=e9.id and e4.domain_id=e9.domain_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and f3.id=e5.work_id and f4.id=e6.topic_id and en0.id=e3.field_id and en1.id=e8.field_id and en2.id=e4.domain_id;
SELECT en0.name, f1.name, e0.work_id, f0.name
FROM uspto.topic_patent1 topic0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_keywords_topics e1, keyword en0
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.name=e1.word;
SELECT f2.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent work1, uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.topic_id = topic0.id and f2.name = work0.name and f0.name = work1.name and e0.topic_id=e1.topic_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.work_id;
SELECT en2.name, en0.name, en1.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent1 topic0, uspto.field_patent field0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, subfield en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e1.subfield_id;
SELECT f1.name, f0.name, en0.name
FROM uspto.topic_patent2 topic0, uspto.topic_patent1 topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent2 topic0, uspto.topic_patent1 topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent1 topic0, uspto.field_patent field0, uspto.subfield_patent2 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT f0.name, f1.name, f2.name, f2.ror
FROM uspto.institution2 institution2, uspto.institution2 institution0, uspto.institution institution1, filter_institution2 f0, filter_institution2 f1, institutions_child_of_institutions e0, filter_institution2 f2, institutions_child_of_institutions e1
WHERE f2.ror = institution0.ror and f0.ror = institution2.ror and f1.ror = institution1.ror and e0.associated_institution_id=e1.institution_id and f0.id=e0.institution_id and f1.id=e0.associated_institution_id and f2.id=e1.associated_institution_id;
SELECT f0.name, f2.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.inventors2 author0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent1 topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT f0.works_count, f0.name, en2.name, en0.name, f0.cited_by_count, en1.name
FROM uspto.topic_patent1 topic0, uspto.subfield_patent subfield0, uspto.field_patent field0, filter_topic1 f0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, subfield en1, domain en2
WHERE e1.field_id = field0.id and e0.id = topic0.id and e0.subfield_id = subfield0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and f0.id=e0.id and en0.id=e1.field_id and en1.id=e0.subfield_id and en2.id=e2.domain_id;
SELECT f0.name, en0.name, f1.name, f2.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, uspto.subfield_patent2 subfield0, uspto.publication_cited_by_patent2 work1, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and f0.name = work0.name and e2.subfield_id = subfield0.id and f1.name = work1.name and e0.related_work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en2.name, f0.name, en1.name, en0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent topic0, uspto.field_patent2 field0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, subfield en1, field en2
WHERE e2.field_id = field0.id and e0.id = topic0.id and e1.subfield_id = subfield0.id and e0.id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and en0.name=e0.word and en1.id=e1.subfield_id and en2.id=e2.field_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.topic_patent2 topic0, uspto.subfield_patent subfield0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent2 topic0, uspto.topic_patent topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT f0.name, f3.name, f1.name, f2.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.publication_cited_by_patent2 work1, uspto.topic_patent1 topic1, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_topic1 f2, openalex_subset_topics_topics e1, filter_work3 f3, openalex_subset_works_topics_final e2
WHERE e0.topic_id = topic0.id and e1.sibling_id = topic1.id and f0.name = work0.name and f3.name = work1.name and e0.topic_id=e1.id and e1.sibling_id=e2.topic_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.sibling_id and f3.id=e2.work_id;
SELECT en2.name, en0.name, f0.name, f0.cited_by_count, en1.name
FROM uspto.topic_patent2 topic0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, subfield en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e1.subfield_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.publication_cited_by_patent2 work1, uspto.publication_cited_by_patent work0, uspto.inventors2 author0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.inventors1 author0, uspto.publication_cited_by_patent work1, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, uspto.field_patent2 field0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e2.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en2.name, en0.name, en1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, subfield en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e1.subfield_id;
SELECT f0.name, en1.name, f1.name, en0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_keywords_topics e1, openalex_subset_topics_subfield e2, keyword en0, subfield en1
WHERE e0.topic_id = topic0.id and e2.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e0.topic_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.name=e1.word and en1.id=e2.subfield_id;
SELECT f0.name, f2.name, f1.name
FROM uspto.inventors author0, uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT en1.name, f1.name, en2.name, en0.name, f0.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent2 topic0, uspto.field_patent1 field0, uspto.subfield_patent subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, openalex_subset_field_domain e3, field en0, subfield en1, domain en2
WHERE e2.field_id = field0.id and e0.topic_id = topic0.id and f0.name = work0.name and e1.subfield_id = subfield0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and e2.field_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id and en2.id=e3.domain_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_keywords_topics e1, keyword en0
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.name=e1.word;
SELECT f1.name, f2.name, f0.name
FROM uspto.institution1 institution1, uspto.institution1 institution0, uspto.publication_cited_by_patent work0, filter_work3 f0, filter_institution2 f1, openalex_subset_works_institution e0, filter_institution2 f2, institutions_child_of_institutions e1
WHERE f0.name = work0.name and f2.ror = institution0.ror and f1.ror = institution1.ror and e0.institution_id=e1.institution_id and f0.id=e0.work_id and f1.id=e0.institution_id and f2.id=e1.associated_institution_id;
SELECT e0.work_id, f1.name, en0.name, en1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.field_patent1 field0, uspto.publication_cited_by_patent2 work0, uspto.subfield_patent subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en3.name, en0.name, en1.name, en2.name
FROM uspto.topic_patent topic0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, topic en2, subfield en3
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e0.id and en3.id=e1.subfield_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.inventors author0, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_keywords_topics e2, keyword en0
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.name=e2.word;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.field_patent1 field0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT f0.name, f2.name, f1.name
FROM uspto.topic_patent1 topic0, uspto.inventors2 author0, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT f0.name, en0.name, f1.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, uspto.field_patent1 field0, uspto.subfield_patent subfield0, uspto.publication_cited_by_patent2 work1, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, openalex_subset_subfield_field e3, filter_topic1 f3, openalex_subset_works_topics_final e4, openalex_subset_topics_subfield e5, openalex_subset_subfield_field e6, field en0
WHERE e4.topic_id = topic0.id and f1.name = work1.name and e5.subfield_id = subfield0.id and f0.name = work0.name and e3.field_id = field0.id and e0.work_id=e1.work_id and e1.topic_id=e2.id and e2.subfield_id=e3.id and e0.related_work_id=e4.work_id and e4.topic_id=e5.id and e5.subfield_id=e6.id and e3.field_id=e6.field_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.topic_id and f3.id=e4.topic_id and en0.id=e3.field_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, subfield en0
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e1.subfield_id;
SELECT en0.name, en1.name, f0.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, keyword en0, subfield en1
WHERE e0.id = topic0.id and e1.subfield_id = subfield0.id and e0.id=e1.id and f0.id=e0.id and en0.name=e0.word and en1.id=e1.subfield_id;
SELECT f2.name, f0.name, e0.related_work_id, e0.work_id, f1.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent1 work1, uspto.publication_cited_by_patent work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_keywords_topics e1, keyword en0
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.name=e1.word;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.subfield_patent2 subfield0, uspto.inventors1 author0, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e2.subfield_id = subfield0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en0.name, f0.name, f2.name, f3.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, uspto.topic_patent2 topic1, uspto.subfield_patent subfield0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, filter_topic1 f3, openalex_subset_topics_subfield e3, openalex_subset_works_topics_final e4, subfield en0
WHERE e3.id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and e1.topic_id = topic1.id and e0.work_id=e1.work_id and e1.topic_id=e2.id and e2.subfield_id=e3.subfield_id and e0.work_id=e4.work_id and e3.id=e4.topic_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and f3.id=e3.id and en0.id=e2.subfield_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.publication_cited_by_patent1 work1, uspto.publication_cited_by_patent work0, uspto.topic_patent topic0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f0.name = work1.name and f1.name = work0.name and e0.work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.topic_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent1 topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT f0.name, en0.name, f1.name, f2.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, uspto.subfield_patent subfield0, uspto.publication_cited_by_patent2 work1, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and f0.name = work1.name and e0.related_work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.inventors1 author0, uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent2 topic0, uspto.subfield_patent subfield0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, subfield en0
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e1.subfield_id;
SELECT en2.name, en3.name, en0.name, en1.name
FROM uspto.topic_patent2 topic0, uspto.subfield_patent2 subfield0, uspto.field_patent1 field0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, topic en1, subfield en2, domain en3
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and en0.id=e1.field_id and en1.id=e0.id and en2.id=e0.subfield_id and en3.id=e2.domain_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.field_patent field0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e2.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.topic_patent1 topic1, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT en0.name, en2.name, en4.name, en1.name, en3.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent1 topic0, uspto.field_patent1 field0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, openalex_subset_field_domain e3, keyword en0, field en1, topic en2, subfield en3, domain en4
WHERE e2.field_id = field0.id and e0.id = topic0.id and e1.subfield_id = subfield0.id and e0.id=e1.id and e1.subfield_id=e2.id and e2.field_id=e3.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e0.id and en3.id=e1.subfield_id and en4.id=e3.domain_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent1 work1, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.topic_patent topic0, uspto.field_patent field0, uspto.publication_cited_by_patent2 work0, uspto.subfield_patent subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e2.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.topic_patent2 topic1, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT f2.name, f0.name, en0.name, f1.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent1 topic0, uspto.topic_patent2 topic1, uspto.subfield_patent subfield0, filter_topic1 f0, openalex_subset_topics_subfield e0, filter_topic1 f1, openalex_subset_topics_subfield e1, filter_work3 f2, openalex_subset_works_topics_final e2, subfield en0
WHERE e1.id = topic0.id and f2.name = work0.name and e0.subfield_id = subfield0.id and e0.id = topic1.id and e0.subfield_id=e1.subfield_id and e1.id=e2.topic_id and f0.id=e0.id and f1.id=e1.id and f2.id=e2.work_id and en0.id=e0.subfield_id;
SELECT f2.name, f3.name, f0.name, f1.name
FROM uspto.publication_cited_by_patent work0, uspto.inventors2 author0, uspto.institution institution0, uspto.publication_cited_by_patent work1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_institution2 f3, openalex_subset_works_institution e2
WHERE f1.name = work0.name and f0.name = author0.name and f2.name = work1.name and f3.ror = institution0.ror and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.institution_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.topic_patent1 topic1, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT f2.name, f3.name, f0.name, f1.name
FROM uspto.publication_cited_by_patent1 work1, uspto.institution institution0, uspto.publication_cited_by_patent work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_institution2 f3, openalex_subset_works_institution e2
WHERE f1.name = work0.name and f3.ror = institution0.ror and f2.name = work1.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.institution_id;
SELECT en2.name, en0.name, f0.works_count, f0.name, f0.cited_by_count, en1.name
FROM uspto.topic_patent2 topic0, uspto.field_patent1 field0, uspto.subfield_patent subfield0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, subfield en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e1.subfield_id;
SELECT f2.name, en1.name, f1.name, en0.name, f0.name, en2.name
FROM uspto.subfield_patent1 subfield1, uspto.publication_cited_by_patent work0, uspto.topic_patent topic0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, uspto.topic_patent1 topic1, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, filter_topic1 f2, openalex_subset_topics_subfield e2, openalex_subset_subfield_field e3, openalex_subset_subfield_field e4, openalex_subset_works_topics_final e5, field en0, subfield en1, subfield en2
WHERE e2.id = topic1.id and e1.subfield_id = subfield0.id and e0.topic_id = topic0.id and f0.name = work0.name and e2.subfield_id = subfield1.id and e3.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e3.id and e2.subfield_id=e4.id and e3.field_id=e4.field_id and e0.work_id=e5.work_id and e2.id=e5.topic_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e2.id and en0.id=e3.field_id and en1.id=e1.subfield_id and en2.id=e2.subfield_id;
SELECT f2.name, f0.name, f2.orcid, f1.name
FROM uspto.inventors1 author0, uspto.publication_cited_by_patent work1, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f2.name = author0.name and f0.name = work1.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent1 topic0, uspto.field_patent1 field0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.topic_id = topic0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.topic_patent1 topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT f2.name, f0.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.topic_patent2 topic1, uspto.publication_cited_by_patent1 work0, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.sibling_id=e1.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id;
SELECT f1.type, en0.name, f0.name, f1.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_work3 f1, openalex_subset_works_topics_final e1, keyword en0
WHERE e0.id = topic0.id and f1.name = work0.name and e0.id=e1.topic_id and f0.id=e0.id and f1.id=e1.work_id and en0.name=e0.word;
SELECT f2.name, f0.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, uspto.topic_patent topic1, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.sibling_id=e1.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id;
SELECT f3.name, f1.name, f3.orcid, f0.name, f2.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent work0, uspto.publication_cited_by_patent2 work1, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_work3 f2, openalex_subset_works_topics_final e1, filter_author2 f3, openalex_subset_works_author e2
WHERE f3.name = author0.name and f2.name = work0.name and f0.name = work1.name and e0.topic_id=e1.topic_id and e1.work_id=e2.work_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.work_id and f3.id=e2.author_id;
SELECT f2.name, f0.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.topic_patent topic1, uspto.publication_cited_by_patent2 work0, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.sibling_id=e1.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id;
SELECT f2.name, f1.name, e0.work_id, f0.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent2 topic1, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_topic1 f2, openalex_subset_topics_topics e1
WHERE e1.sibling_id = topic0.id and f0.name = work0.name and e0.topic_id = topic1.id and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.sibling_id;
SELECT f0.name, e0.work_id, e1.topic_id, f2.name, f1.name, e0.author_id
FROM uspto.inventors author0, uspto.publication_cited_by_patent work0, uspto.topic_patent topic0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.field_patent field0, uspto.subfield_patent subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e0.topic_id = topic0.id and f0.name = work0.name and e1.subfield_id = subfield0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT f0.name, f2.name, f1.name
FROM uspto.inventors author0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT f1.name, f4.name, f2.name, f0.name, f3.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, uspto.publication_cited_by_patent work1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_author2 f3, openalex_subset_works_author e2, filter_topic1 f4, openalex_subset_works_topics_final e3, openalex_subset_works_topics_final e4
WHERE e3.topic_id = topic0.id and f1.name = work0.name and f2.name = work1.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and e0.work_id=e3.work_id and e1.related_work_id=e4.work_id and e3.topic_id=e4.topic_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.author_id and f4.id=e3.topic_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent work1, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT f1.name, e0.id, f0.name, e0.sibling_id, f2.name
FROM uspto.topic_patent2 topic0, uspto.topic_patent1 topic1, uspto.publication_cited_by_patent1 work0, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.sibling_id=e1.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id;
SELECT f2.name, f3.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.publication_cited_by_patent work0, uspto.publication_cited_by_patent2 work1, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_work3 f2, openalex_subset_works_topics_final e1, filter_author2 f3, openalex_subset_works_author e2
WHERE e0.topic_id = topic0.id and f0.name = work0.name and f2.name = work1.name and e0.topic_id=e1.topic_id and e1.work_id=e2.work_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.work_id and f3.id=e2.author_id;
SELECT en3.name, en0.name, en1.name, en2.name
FROM uspto.subfield_patent2 subfield1, uspto.topic_patent1 topic0, uspto.field_patent1 field0, uspto.subfield_patent1 subfield0, openalex_subset_subfield_field e0, openalex_subset_subfield_field e1, openalex_subset_topics_subfield e2, field en0, topic en1, subfield en2, subfield en3
WHERE e2.id = topic0.id and e1.id = subfield0.id and e0.id = subfield1.id and e0.field_id = field0.id and e0.field_id=e1.field_id and e1.id=e2.subfield_id and en0.id=e0.field_id and en1.id=e2.id and en2.id=e1.id and en3.id=e0.id;
SELECT f2.name, f1.name, f3.name, f0.name
FROM uspto.inventors author0, uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, uspto.publication_cited_by_patent work1, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_author e1, filter_topic1 f3, openalex_subset_works_topics_final e2
WHERE e2.topic_id = topic0.id and f1.name = author0.name and f2.name = work0.name and f0.name = work1.name and e0.author_id=e1.author_id and e1.work_id=e2.work_id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.work_id and f3.id=e2.topic_id;
SELECT en1.name, en2.name, en0.name, f0.name
FROM uspto.topic_patent2 topic0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, filter_topic1 f0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, subfield en1, domain en2
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and f0.id=e0.id and en0.id=e1.field_id and en1.id=e0.subfield_id and en2.id=e2.domain_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.publication_cited_by_patent work1, uspto.inventors1 author0, uspto.publication_cited_by_patent work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT en2.name, en0.name, en1.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent1 topic0, uspto.field_patent field0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, subfield en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e1.subfield_id;
SELECT en3.name, en0.name, en1.name, en2.name
FROM uspto.subfield_patent2 subfield0, uspto.field_patent1 field0, uspto.topic_patent topic0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, topic en2, subfield en3
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e0.id and en3.id=e1.subfield_id;
SELECT en1.name, f1.name, en2.name, en0.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, openalex_subset_field_domain e3, field en0, subfield en1, domain en2
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and e2.field_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id and en2.id=e3.domain_id;
SELECT en0.name, f0.name, en1.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent1 topic0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, keyword en0, subfield en1
WHERE e0.id = topic0.id and e1.subfield_id = subfield0.id and e0.id=e1.id and f0.id=e0.id and en0.name=e0.word and en1.id=e1.subfield_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e0.topic_id = topic0.id and f0.name = work0.name and e1.subfield_id = subfield0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT f1.name, f0.name, f2.name
FROM uspto.inventors author1, uspto.inventors1 author0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = author1.name and f1.name = work0.name and f2.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.author_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent1 topic0, uspto.field_patent2 field0, uspto.subfield_patent1 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e2.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT e1.work_id, f2.name, f0.name, f1.name
FROM uspto.topic_patent1 topic1, uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.sibling_id=e1.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id;
SELECT f3.name, e0.author_id, f0.name
FROM uspto.inventors author0, uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work1, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_topic1 f3, openalex_subset_works_topics_final e2
WHERE e2.topic_id = topic0.id and f2.name = work0.name and f1.name = work1.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.topic_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.field_patent2 field0, uspto.subfield_patent1 subfield0, filter_institution2 f0, filter_work3 f1, openalex_subset_works_institution e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, openalex_subset_subfield_field e3, openalex_subset_field_domain e4, domain en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and e3.field_id = field0.id and e0.work_id=e1.work_id and e1.topic_id=e2.id and e2.subfield_id=e3.id and e3.field_id=e4.id and f0.id=e0.institution_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e4.domain_id;
SELECT f2.name, f1.name, f0.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, uspto.topic_patent topic1, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_topic1 f2, openalex_subset_topics_topics e1
WHERE f0.name = work0.name and e1.sibling_id = topic0.id and e0.topic_id = topic1.id and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.sibling_id;
SELECT en0.name, f0.name, f1.name, f2.name, en1.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.subfield_patent1 subfield0, uspto.publication_cited_by_patent work1, uspto.subfield_patent subfield1, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, filter_work3 f2, openalex_subset_works_topics_final e2, openalex_subset_topics_subfield e3, subfield en0, subfield en1
WHERE f0.name = work1.name and e0.topic_id = topic0.id and e1.subfield_id = subfield1.id and e3.subfield_id = subfield0.id and f2.name = work0.name and e0.topic_id=e1.id and e0.topic_id=e2.topic_id and e0.topic_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e2.work_id and en0.id=e1.subfield_id and en1.id=e3.subfield_id;
SELECT e1.work_id, f2.name, f0.name, f1.name
FROM uspto.topic_patent1 topic0, uspto.publication_cited_by_patent work0, uspto.topic_patent topic1, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.sibling_id=e1.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id;
SELECT f3.name, f0.name, f1.name, f2.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent1 work0, uspto.publication_cited_by_patent1 work1, uspto.inventors2 author1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_author2 f3, openalex_subset_works_author e2
WHERE f3.name = author1.name and f0.name = author0.name and f1.name = work1.name and f2.name = work0.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.author_id;
SELECT en3.name, en0.name, en1.name, en2.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent2 topic0, uspto.field_patent field0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, topic en2, subfield en3
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e0.id and en3.id=e1.subfield_id;
SELECT en1.name, en2.name, en0.name
FROM uspto.subfield_patent1 subfield0, uspto.field_patent2 field0, openalex_subset_subfield_field e0, openalex_subset_field_domain e1, field en0, subfield en1, domain en2
WHERE e0.field_id = field0.id and e0.id = subfield0.id and e0.field_id=e1.id and en0.id=e0.field_id and en1.id=e0.id and en2.id=e1.domain_id;
SELECT f2.name, f0.name, f1.name
FROM uspto.inventors1 author0, uspto.publication_cited_by_patent2 work1, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1
WHERE f0.name = author0.name and f2.name = work0.name and f1.name = work1.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id;
SELECT en1.name, e0.id, en2.name, en0.name, e0.field_id
FROM uspto.subfield_patent1 subfield0, uspto.field_patent field0, openalex_subset_subfield_field e0, openalex_subset_field_domain e1, field en0, subfield en1, domain en2
WHERE e0.field_id = field0.id and e0.id = subfield0.id and e0.field_id=e1.id and en0.id=e0.field_id and en1.id=e0.id and en2.id=e1.domain_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent2 topic0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en1.name, f1.name, en0.name, f0.name, e0.work_id
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent2 topic0, uspto.field_patent2 field0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.topic_id = topic0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en3.name, en0.name, en1.name, en2.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent2 topic0, uspto.field_patent2 field0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, topic en2, subfield en3
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e0.id and en3.id=e1.subfield_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.field_patent1 field0, uspto.subfield_patent2 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e0.topic_id = topic0.id and f0.name = work0.name and e1.subfield_id = subfield0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.publication_cited_by_patent work1, uspto.inventors2 author0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT en1.name, e0.work_id, f1.name, en2.name, en0.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.subfield_patent subfield0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, openalex_subset_field_domain e3, field en0, subfield en1, domain en2
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and e2.field_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id and en2.id=e3.domain_id;
SELECT en2.name, en0.name, en1.name
FROM uspto.topic_patent1 topic0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, field en0, topic en1, subfield en2
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and en0.id=e1.field_id and en1.id=e0.id and en2.id=e0.subfield_id;
SELECT en1.name, en2.name, en0.name
FROM uspto.subfield_patent2 subfield0, uspto.field_patent2 field0, openalex_subset_subfield_field e0, openalex_subset_field_domain e1, field en0, subfield en1, domain en2
WHERE e0.field_id = field0.id and e0.id = subfield0.id and e0.field_id=e1.id and en0.id=e0.field_id and en1.id=e0.id and en2.id=e1.domain_id;
SELECT en1.name, f0.name, f1.name, en0.name, f2.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, uspto.subfield_patent2 subfield0, uspto.publication_cited_by_patent2 work1, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_work3 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, openalex_subset_subfield_field e3, field en0, subfield en1
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e2.subfield_id = subfield0.id and f2.name = work1.name and e0.topic_id=e1.topic_id and e0.topic_id=e2.id and e2.subfield_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.work_id and en0.id=e3.field_id and en1.id=e2.subfield_id;
SELECT en1.works_count, en1.name, en3.name, en0.name, en2.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent topic0, uspto.field_patent field0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, topic en1, subfield en2, domain en3
WHERE e1.field_id = field0.id and e0.id = topic0.id and e0.subfield_id = subfield0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and en0.id=e1.field_id and en1.id=e0.id and en2.id=e0.subfield_id and en3.id=e2.domain_id;
SELECT en1.name, e0.work_id, e0.topic_id, f1.name, en0.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent1 topic0, uspto.field_patent2 field0, uspto.subfield_patent1 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en1.name, en3.name, en0.name, en2.name
FROM uspto.subfield_patent1 subfield0, uspto.field_patent1 field1, uspto.field_patent2 field0, openalex_subset_field_domain e0, openalex_subset_field_domain e1, openalex_subset_subfield_field e2, field en0, subfield en1, field en2, domain en3
WHERE e2.id = subfield0.id and e1.id = field0.id and e0.id = field1.id and e0.domain_id=e1.domain_id and e1.id=e2.field_id and en0.id=e0.id and en1.id=e2.id and en2.id=e1.id and en3.id=e0.domain_id;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.inventors author0, uspto.subfield_patent subfield0, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e2.subfield_id = subfield0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT f1.name, f3.name, f2.name, f0.name
FROM uspto.inventors1 author0, uspto.institution2 institution0, uspto.topic_patent topic0, filter_institution2 f0, filter_work3 f1, openalex_subset_works_institution e0, filter_topic1 f2, openalex_subset_works_topics_final e1, filter_author2 f3, openalex_subset_works_author e2
WHERE f0.ror = institution0.ror and e1.topic_id = topic0.id and f3.name = author0.name and e0.work_id=e1.work_id and e0.work_id=e2.work_id and f0.id=e0.institution_id and f1.id=e0.work_id and f2.id=e1.topic_id and f3.id=e2.author_id;
SELECT en0.name, f0.name, e0.work_id, f2.name, f1.name
FROM uspto.inventors author0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent2 work0, uspto.subfield_patent subfield0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT f0.name, f2.name, f1.name
FROM uspto.inventors author0, uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT f0.name, f1.name, f2.name, f3.name, f4.name
FROM uspto.topic_patent topic1, uspto.topic_patent1 topic0, uspto.inventors2 author0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, filter_topic1 f3, openalex_subset_topics_topics e2, filter_work3 f4, openalex_subset_works_author e3, openalex_subset_works_topics_final e4
WHERE e2.sibling_id = topic1.id and e1.topic_id = topic0.id and f4.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and e0.author_id=e3.author_id and e3.work_id=e4.work_id and e2.sibling_id=e4.topic_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and f3.id=e2.sibling_id and f4.id=e3.work_id;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.inventors author0, uspto.topic_patent2 topic0, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_keywords_topics e2, keyword en0
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.name=e2.word;
SELECT en0.name, en1.name, f0.name, f1.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent2 topic1, uspto.topic_patent2 topic0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, openalex_subset_topics_subfield e2, keyword en0, subfield en1
WHERE e1.sibling_id = topic0.id and e2.subfield_id = subfield0.id and e0.id = topic1.id and e0.id=e1.id and e1.sibling_id=e2.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word and en1.id=e2.subfield_id;
SELECT f2.name, f3.name, f0.name, f1.name
FROM uspto.inventors author0, uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1, filter_author2 f3, openalex_subset_works_author e2
WHERE e0.id = topic0.id and f2.name = work0.name and f3.name = author0.name and e0.sibling_id=e1.topic_id and e1.work_id=e2.work_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id and f3.id=e2.author_id;
SELECT f2.name, f3.name, f0.name, f1.name
FROM uspto.publication_cited_by_patent work0, uspto.inventors1 author0, uspto.institution institution0, uspto.publication_cited_by_patent2 work1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_institution2 f3, openalex_subset_works_institution e2
WHERE f3.ror = institution0.ror and f0.name = author0.name and f2.name = work0.name and f1.name = work1.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.institution_id;
SELECT en0.name, f2.name, f0.name, f1.name
FROM uspto.topic_patent topic0, uspto.inventors1 author0, uspto.publication_cited_by_patent2 work0, uspto.subfield_patent subfield0, filter_topic1 f0, openalex_subset_topics_subfield e0, filter_work3 f1, openalex_subset_works_topics_final e1, filter_author2 f2, openalex_subset_works_author e2, subfield en0
WHERE e0.id = topic0.id and e0.subfield_id = subfield0.id and f1.name = work0.name and f2.name = author0.name and e0.id=e1.topic_id and e1.work_id=e2.work_id and f0.id=e0.id and f1.id=e1.work_id and f2.id=e2.author_id and en0.id=e0.subfield_id;
SELECT f0.name, f2.name, f1.name
FROM uspto.publication_cited_by_patent1 work1, uspto.institution institution0, uspto.publication_cited_by_patent work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_institution2 f2, openalex_subset_works_institution e1
WHERE f0.name = work1.name and f2.ror = institution0.ror and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.institution_id;
SELECT en0.name, f1.name, f2.name, f0.name
FROM uspto.inventors author0, uspto.topic_patent topic0, uspto.subfield_patent subfield0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent1 topic1, uspto.topic_patent topic0, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, openalex_subset_topics_subfield e1, subfield en0
WHERE e0.sibling_id = topic0.id and e1.subfield_id = subfield0.id and e0.id = topic1.id and e0.sibling_id=e1.id and f0.id=e0.id and f1.id=e0.sibling_id and en0.id=e1.subfield_id;
SELECT f3.name, f0.name, f2.name, f1.name
FROM uspto.inventors1 author0, uspto.publication_cited_by_patent2 work0, uspto.institution1 institution0, uspto.publication_cited_by_patent work1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_institution2 f3, openalex_subset_works_institution e2
WHERE f2.name = work0.name and f3.ror = institution0.ror and f1.name = work1.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.institution_id;
SELECT f3.name, f0.name, f2.name, f1.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, uspto.inventors1 author0, uspto.topic_patent1 topic1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, filter_topic1 f3, openalex_subset_topics_topics e2
WHERE e1.topic_id = topic0.id and e2.id = topic1.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.sibling_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and f3.id=e2.id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent topic1, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.field_patent field0, uspto.publication_cited_by_patent2 work0, uspto.subfield_patent2 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e2.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en3.name, en0.name, en1.name, en2.name
FROM uspto.topic_patent topic0, uspto.field_patent1 field0, uspto.subfield_patent subfield0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, topic en1, subfield en2, domain en3
WHERE e1.field_id = field0.id and e0.id = topic0.id and e0.subfield_id = subfield0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and en0.id=e1.field_id and en1.id=e0.id and en2.id=e0.subfield_id and en3.id=e2.domain_id;
SELECT f2.name, f0.name, f1.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent1 topic1, uspto.publication_cited_by_patent1 work0, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.sibling_id=e1.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id;
SELECT f0.name, f2.name, e0.work_id, f1.name
FROM uspto.publication_cited_by_patent work0, uspto.inventors2 author0, uspto.topic_patent topic0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent topic0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_keywords_topics e1, keyword en0
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.name=e1.word;
SELECT en1.name, en0.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent2 topic0, uspto.field_patent field0, filter_topic1 f0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, field en0, subfield en1
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and f0.id=e0.id and en0.id=e1.field_id and en1.id=e0.subfield_id;
SELECT en0.name, en1.name, f0.name, f1.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent1 topic0, uspto.topic_patent2 topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, openalex_subset_topics_subfield e2, keyword en0, subfield en1
WHERE e1.sibling_id = topic0.id and e2.subfield_id = subfield0.id and e0.id = topic1.id and e0.id=e1.id and e1.sibling_id=e2.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word and en1.id=e2.subfield_id;
SELECT en1.name, en2.name, en0.name
FROM uspto.field_patent2 field0, uspto.subfield_patent subfield0, openalex_subset_subfield_field e0, openalex_subset_field_domain e1, field en0, subfield en1, domain en2
WHERE e0.field_id = field0.id and e0.id = subfield0.id and e0.field_id=e1.id and en0.id=e0.field_id and en1.id=e0.id and en2.id=e1.domain_id;
SELECT en0.name, f1.name, e0.work_id, f0.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_keywords_topics e1, keyword en0
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.name=e1.word;
SELECT f2.name, f1.works_count, f1.name, f1.cited_by_count, f0.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent topic1, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_topic1 f2, openalex_subset_topics_topics e1
WHERE e1.sibling_id = topic0.id and f0.name = work0.name and e0.topic_id = topic1.id and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.sibling_id;
SELECT e1.subfield_id, en0.name, en1.name, en2.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent topic0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, keyword en0, topic en1, subfield en2
WHERE e0.id = topic0.id and e1.subfield_id = subfield0.id and e0.id=e1.id and en0.name=e0.word and en1.id=e0.id and en2.id=e1.subfield_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.publication_cited_by_patent work1, uspto.inventors1 author0, uspto.publication_cited_by_patent work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = work1.name and f2.name = author0.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT f2.name, e0.work_id, e0.related_work_id, f0.name, f1.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent1 work1, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f2.name = author0.name and f1.name = work0.name and f0.name = work1.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT en0.name, en1.name, f0.name, f1.name
FROM uspto.subfield_patent2 subfield0, uspto.field_patent1 field0, uspto.topic_patent topic0, openalex_subset_subfield_field e0, filter_topic1 f0, openalex_subset_topics_subfield e1, filter_work3 f1, openalex_subset_works_topics_final e2, field en0, subfield en1
WHERE e0.field_id = field0.id and e1.id = topic0.id and e0.id = subfield0.id and e0.id=e1.subfield_id and e1.id=e2.topic_id and f0.id=e1.id and f1.id=e2.work_id and en0.id=e0.field_id and en1.id=e0.id;
SELECT en0.name, f1.name, en1.name, f0.name
FROM uspto.topic_patent topic0, uspto.field_patent1 field0, uspto.subfield_patent2 subfield0, uspto.topic_patent2 topic1, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.id = topic0.id and e0.sibling_id = topic1.id and e1.subfield_id = subfield0.id and e2.field_id = field0.id and e0.sibling_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and f1.id=e0.sibling_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT f2.name, f0.name, f2.cited_by_count, f2.works_count, f1.name, f2.ror
FROM uspto.publication_cited_by_patent1 work1, uspto.institution2 institution0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_institution2 f2, openalex_subset_works_institution e1
WHERE f0.name = work1.name and f2.ror = institution0.ror and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.institution_id;
SELECT f2.name, f3.name, f0.name, f1.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent1 work1, uspto.publication_cited_by_patent2 work0, uspto.institution2 institution0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_institution2 f3, openalex_subset_works_institution e2
WHERE f1.name = work0.name and f0.name = author0.name and f2.name = work1.name and f3.ror = institution0.ror and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.institution_id;
SELECT f1.cited_by_count, f1.name, f2.name, f0.cited_by_count, f0.name
FROM uspto.publication_cited_by_patent work1, uspto.inventors1 author0, uspto.publication_cited_by_patent work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f2.name = author0.name and f0.name = work1.name and f1.name = work0.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT f0.name, f2.name, f1.name
FROM uspto.inventors author0, uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT f2.name, f0.name, f1.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent1 work1, uspto.publication_cited_by_patent work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1
WHERE f2.name = work0.name and f0.name = author0.name and f1.name = work1.name and e0.work_id=e1.related_work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.work_id;
SELECT en3.name, en0.name, en1.name, en2.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent topic0, uspto.field_patent field0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, topic en2, subfield en3
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e0.id and en3.id=e1.subfield_id;
SELECT f0.name, f1.name, f2.name, en0.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent2 topic0, uspto.inventors1 author0, uspto.subfield_patent2 subfield0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = author0.name and f0.name = work0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, uspto.inventors2 author0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_keywords_topics e2, keyword en0
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.name=e2.word;
SELECT e0.work_id, f1.name, en2.name, en0.name, en1.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.field_patent2 field0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, openalex_subset_field_domain e3, field en0, subfield en1, domain en2
WHERE e2.field_id = field0.id and f0.name = work0.name and e1.subfield_id = subfield0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and e2.field_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id and en2.id=e3.domain_id;
SELECT en0.name, f1.name, f1.cited_by_count, f0.name, f1.works_count
FROM uspto.topic_patent1 topic0, uspto.topic_patent topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT en2.name, en3.name, en0.name, en1.name
FROM uspto.topic_patent2 topic0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, topic en1, subfield en2, domain en3
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and en0.id=e1.field_id and en1.id=e0.id and en2.id=e0.subfield_id and en3.id=e2.domain_id;
SELECT f2.name, f0.name, f1.name
FROM uspto.topic_patent2 topic1, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_author2 f2, filter_work3 f3, openalex_subset_works_author e1, openalex_subset_works_topics_final e2, openalex_subset_works_topics_final e3
WHERE e0.sibling_id = topic0.id and f3.name = work0.name and e0.id = topic1.id and e1.work_id=e2.work_id and e0.id=e2.topic_id and e1.work_id=e3.work_id and e0.sibling_id=e3.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.author_id and f3.id=e1.work_id;
SELECT en1.name, e0.work_id, f1.name, en0.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent topic0, uspto.field_patent field0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.topic_id = topic0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent2 work0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_work3 f1, openalex_subset_works_topics_final e1, keyword en0
WHERE e0.id = topic0.id and f1.name = work0.name and e0.id=e1.topic_id and f0.id=e0.id and f1.id=e1.work_id and en0.name=e0.word;
SELECT f2.name, f2.type, f0.name, f1.name
FROM uspto.topic_patent1 topic1, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.sibling_id=e1.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id;
SELECT en1.name, f1.name, en2.name, en0.name, f0.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent1 topic0, uspto.field_patent field0, uspto.subfield_patent1 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, openalex_subset_field_domain e3, field en0, subfield en1, domain en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and e2.field_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id and en2.id=e3.domain_id;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent1 topic0, uspto.inventors2 author0, uspto.subfield_patent2 subfield0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT f2.name, e0.work_id, f2.orcid, f1.name
FROM uspto.topic_patent2 topic0, uspto.inventors2 author0, uspto.publication_cited_by_patent1 work0, filter_topic1 f0, filter_work3 f1, openalex_subset_works_topics_final e0, filter_author2 f2, openalex_subset_works_author e1
WHERE e0.topic_id = topic0.id and f1.name = work0.name and f2.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.topic_id and f1.id=e0.work_id and f2.id=e1.author_id;
SELECT f1.name, f2.name, f0.name
FROM uspto.institution institution0, uspto.institution2 institution1, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_institution2 f1, openalex_subset_works_institution e0, filter_institution2 f2, institutions_child_of_institutions e1
WHERE f0.name = work0.name and f2.ror = institution0.ror and f1.ror = institution1.ror and e0.institution_id=e1.institution_id and f0.id=e0.work_id and f1.id=e0.institution_id and f2.id=e1.associated_institution_id;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.institution institution0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent2 work0, filter_institution2 f0, filter_work3 f1, openalex_subset_works_institution e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_keywords_topics e2, keyword en0
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.ror = institution0.ror and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.institution_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.name=e2.word;
SELECT e1.work_id, f0.name, f1.name, e0.work_id, f2.name
FROM uspto.publication_cited_by_patent1 work1, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.topic_id = topic0.id and f0.name = work1.name and f2.name = work0.name and e0.topic_id=e1.topic_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.work_id;
SELECT f2.name, en0.name, f0.name, f1.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent2 topic1, uspto.publication_cited_by_patent1 work0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, filter_work3 f2, openalex_subset_works_topics_final e2, keyword en0
WHERE e1.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.id=e1.id and e1.sibling_id=e2.topic_id and f0.id=e0.id and f1.id=e1.sibling_id and f2.id=e2.work_id and en0.name=e0.word;
SELECT f1.name, en1.name, en0.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.publication_cited_by_patent work0, uspto.field_patent field0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, openalex_subset_subfield_field e3, subfield en0, field en1
WHERE f1.name = work0.name and e1.topic_id = topic0.id and e3.field_id = field0.id and e0.work_id=e1.work_id and e1.topic_id=e2.id and e2.subfield_id=e3.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id and en1.id=e3.field_id;
SELECT en2.name, en1.name, en0.name, f0.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent2 topic0, uspto.field_patent field0, filter_topic1 f0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, domain en0, field en1, subfield en2
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and f0.id=e0.id and en0.id=e2.domain_id and en1.id=e1.field_id and en2.id=e0.subfield_id;
SELECT f2.name, f0.name, f1.name
FROM uspto.inventors author1, uspto.inventors1 author0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f0.name = author1.name and f1.name = work0.name and f2.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.author_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.institution institution0, uspto.inventors2 author0, uspto.publication_cited_by_patent2 work0, filter_institution2 f0, filter_author2 f1, openalex_subset_author_institution e0, filter_work3 f2, openalex_subset_works_author e1
WHERE f2.name = work0.name and f1.name = author0.name and f0.ror = institution0.ror and e0.id=e1.author_id and f0.id=e0.institution_id and f1.id=e0.id and f2.id=e1.work_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.subfield_patent subfield0, uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en0.name, e2.work_id, f1.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, uspto.field_patent field0, openalex_subset_subfield_field e0, filter_topic1 f0, openalex_subset_topics_subfield e1, filter_work3 f1, openalex_subset_works_topics_final e2, field en0
WHERE e0.field_id = field0.id and e1.id = topic0.id and f1.name = work0.name and e0.id=e1.subfield_id and e1.id=e2.topic_id and f0.id=e1.id and f1.id=e2.work_id and en0.id=e0.field_id;
SELECT f0.name, f3.name, f1.name, f2.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent1 work0, uspto.institution2 institution0, uspto.publication_cited_by_patent2 work1, filter_institution2 f0, filter_author2 f1, openalex_subset_author_institution e0, filter_work3 f2, openalex_subset_works_author e1, filter_work3 f3, openalex_subset_works_related_works e2
WHERE f3.name = work1.name and f2.name = work0.name and f1.name = author0.name and f0.ror = institution0.ror and e0.id=e1.author_id and e1.work_id=e2.work_id and f0.id=e0.institution_id and f1.id=e0.id and f2.id=e1.work_id and f3.id=e2.related_work_id;
SELECT f3.name, f2.name, f0.name, f1.name
FROM uspto.inventors1 author0, uspto.institution2 institution0, uspto.publication_cited_by_patent1 work0, filter_topic1 f0, filter_work3 f1, openalex_subset_works_topics_final e0, filter_author2 f2, openalex_subset_works_author e1, filter_institution2 f3, openalex_subset_author_institution e2
WHERE f1.name = work0.name and f3.ror = institution0.ror and f2.name = author0.name and e0.work_id=e1.work_id and e1.author_id=e2.id and f0.id=e0.topic_id and f1.id=e0.work_id and f2.id=e1.author_id and f3.id=e2.institution_id;
SELECT f2.name, f1.name, f3.name, f0.name, f4.name
FROM uspto.topic_patent1 topic0, uspto.inventors2 author0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1, filter_topic1 f3, openalex_subset_works_topics_final e2, filter_topic1 f4, openalex_subset_topics_topics e3
WHERE e2.topic_id = topic0.id and f0.name = work0.name and f1.name = author0.name and e0.author_id=e1.id and e0.work_id=e2.work_id and e2.topic_id=e3.sibling_id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id and f3.id=e2.topic_id and f4.id=e3.id;
SELECT en2.name, en0.name, f0.name, en1.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent topic0, uspto.field_patent2 field0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, keyword en1, subfield en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and en0.id=e2.field_id and en1.name=e0.word and en2.id=e1.subfield_id;
SELECT en1.name, en0.name, f0.name, f1.name
FROM uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, openalex_subset_subfield_field e0, filter_topic1 f0, openalex_subset_topics_subfield e1, filter_work3 f1, openalex_subset_works_topics_final e2, field en0, subfield en1
WHERE e0.field_id = field0.id and e0.id = subfield0.id and e1.id = topic0.id and f1.name = work0.name and e0.id=e1.subfield_id and e1.id=e2.topic_id and f0.id=e1.id and f1.id=e2.work_id and en0.id=e0.field_id and en1.id=e0.id;
SELECT f1.name, f0.name, f3.name, f2.name
FROM uspto.institution institution0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_institution2 f1, openalex_subset_author_institution e0, filter_work3 f2, openalex_subset_works_institution e1, filter_topic1 f3, openalex_subset_works_topics_final e2
WHERE e2.topic_id = topic0.id and f2.name = work0.name and f1.ror = institution0.ror and e0.institution_id=e1.institution_id and e1.work_id=e2.work_id and f0.id=e0.id and f1.id=e0.institution_id and f2.id=e1.work_id and f3.id=e2.topic_id;
SELECT f1.type, en1.name, f0.name, en0.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, uspto.field_patent1 field0, openalex_subset_field_domain e0, openalex_subset_subfield_field e1, filter_topic1 f0, openalex_subset_topics_subfield e2, filter_work3 f1, openalex_subset_works_topics_final e3, field en0, subfield en1
WHERE e2.id = topic0.id and f1.name = work0.name and e0.id = field0.id and e0.id=e1.field_id and e1.id=e2.subfield_id and e2.id=e3.topic_id and f0.id=e2.id and f1.id=e3.work_id and en0.id=e0.id and en1.id=e1.id;
SELECT en1.name, en3.name, en0.name, en2.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent2 topic0, uspto.field_patent2 field0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, keyword en1, topic en2, subfield en3
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and en0.id=e2.field_id and en1.name=e0.word and en2.id=e0.id and en3.id=e1.subfield_id;
SELECT f3.name, f0.name, f1.name, e0.author_id, f2.name
FROM uspto.institution institution0, uspto.publication_cited_by_patent work0, uspto.inventors2 author0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_institution2 f3, openalex_subset_works_institution e2
WHERE f1.name = work0.name and f3.ror = institution0.ror and f0.name = author0.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.institution_id;
SELECT f2.name, e0.related_work_id, f1.name, f0.name, e0.work_id
FROM uspto.publication_cited_by_patent1 work1, uspto.inventors1 author0, uspto.publication_cited_by_patent work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1
WHERE f1.name = work0.name and f2.name = author0.name and f0.name = work1.name and e0.related_work_id=e1.work_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id;
SELECT en1.name, en0.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, keyword en0, subfield en1
WHERE e0.id = topic0.id and e1.subfield_id = subfield0.id and e0.id=e1.id and f0.id=e0.id and en0.name=e0.word and en1.id=e1.subfield_id;
SELECT f2.name, f1.name, e0.work_id, e2.work_id, e1.institution_id, f0.name, e0.author_id, f3.name
FROM uspto.inventors author0, uspto.institution2 institution0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1, filter_work3 f3, openalex_subset_works_institution e2
WHERE f1.name = author0.name and f3.name = work0.name and f2.ror = institution0.ror and e0.author_id=e1.id and e1.institution_id=e2.institution_id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id and f3.id=e2.work_id;
SELECT f3.name, f1.name, f0.name
FROM uspto.topic_patent topic1, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent2 work0, uspto.publication_cited_by_patent work1, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_topic1 f2, openalex_subset_topics_topics e1, filter_work3 f3, openalex_subset_works_topics_final e2
WHERE f3.name = work1.name and f0.name = work0.name and e1.sibling_id = topic0.id and e0.topic_id = topic1.id and e0.topic_id=e1.id and e1.sibling_id=e2.topic_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.sibling_id and f3.id=e2.work_id;
SELECT f1.name, f0.name, f2.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, uspto.topic_patent topic1, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, filter_work3 f2, openalex_subset_works_topics_final e1
WHERE e0.sibling_id = topic0.id and f2.name = work0.name and e0.id = topic1.id and e0.id=e1.topic_id and f0.id=e0.id and f1.id=e0.sibling_id and f2.id=e1.work_id;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.inventors2 author0, uspto.publication_cited_by_patent2 work0, uspto.subfield_patent2 subfield0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT f2.name, f0.name, f3.name, f1.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent work0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent work1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_topic1 f3, openalex_subset_works_topics_final e2
WHERE e2.topic_id = topic0.id and f2.name = work1.name and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.topic_id;
SELECT en2.name, en1.name, en0.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.field_patent1 field0, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, domain en1, subfield en2
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and f0.id=e0.id and en0.id=e1.field_id and en1.id=e2.domain_id and en2.id=e0.subfield_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent1 topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT f3.name, f2.name, f0.name, f1.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent1 work0, uspto.inventors author1, uspto.publication_cited_by_patent2 work1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_author2 f3, openalex_subset_works_author e2
WHERE f1.name = work0.name and f3.name = author0.name and f2.name = work1.name and f0.name = author1.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.author_id;
SELECT f3.name, f0.name, e0.work_id, f2.name, f1.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.topic_patent1 topic1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, filter_topic1 f3, openalex_subset_topics_topics e2
WHERE e1.topic_id = topic0.id and e2.id = topic1.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.sibling_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and f3.id=e2.id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT f0.name, f3.name, f1.name, f2.name
FROM uspto.inventors author0, uspto.publication_cited_by_patent work0, uspto.institution2 institution0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1, filter_institution2 f3, openalex_subset_author_institution e2
WHERE f2.name = author0.name and f3.ror = institution0.ror and f1.name = work0.name and e0.related_work_id=e1.work_id and e1.author_id=e2.id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id and f3.id=e2.institution_id;
SELECT f3.name, f2.name, f1.name, f0.name
FROM uspto.inventors author0, uspto.institution2 institution0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1, filter_institution2 f3, institutions_child_of_institutions e2
WHERE f0.name = work0.name and f1.name = author0.name and f2.ror = institution0.ror and e0.author_id=e1.id and e1.institution_id=e2.institution_id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id and f3.id=e2.associated_institution_id;
SELECT f3.type, f1.name, f0.name, f3.name, e2.work_id, f2.name
FROM uspto.publication_cited_by_patent2 work0, uspto.institution2 institution0, uspto.institution institution1, filter_author2 f0, filter_institution2 f1, openalex_subset_author_institution e0, filter_institution2 f2, institutions_child_of_institutions e1, filter_work3 f3, openalex_subset_works_author e2
WHERE f3.name = work0.name and f1.ror = institution0.ror and f2.ror = institution1.ror and e0.institution_id=e1.associated_institution_id and e0.id=e2.author_id and f0.id=e0.id and f1.id=e0.institution_id and f2.id=e1.institution_id and f3.id=e2.work_id;
SELECT f1.name, f2.name, f3.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.institution institution1, uspto.inventors1 author0, uspto.institution2 institution0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1, filter_institution2 f3, institutions_child_of_institutions e2
WHERE f3.ror = institution0.ror and f0.name = work0.name and f1.name = author0.name and f2.ror = institution1.ror and e0.author_id=e1.id and e1.institution_id=e2.institution_id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id and f3.id=e2.associated_institution_id;
SELECT en0.name, e0.work_id, f0.name
FROM uspto.topic_patent1 topic0, uspto.field_patent2 field0, uspto.publication_cited_by_patent2 work0, uspto.subfield_patent1 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id;
SELECT f1.name, f0.name, e1.work_id, e0.institution_id, f2.name, e1.work_id, e0.id
FROM uspto.inventors author0, uspto.publication_cited_by_patent work0, uspto.institution1 institution0, filter_author2 f0, filter_institution2 f1, openalex_subset_author_institution e0, filter_work3 f2, openalex_subset_works_institution e1
WHERE f2.name = work0.name and f1.ror = institution0.ror and f0.name = author0.name and e0.institution_id=e1.institution_id and f0.id=e0.id and f1.id=e0.institution_id and f2.id=e1.work_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.publication_cited_by_patent work0, uspto.inventors2 author0, uspto.field_patent field0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, openalex_subset_subfield_field e3, field en0
WHERE e3.field_id = field0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and e2.subfield_id=e3.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e3.field_id;
SELECT en1.name, f0.name, en0.name, f1.name
FROM uspto.topic_patent2 topic0, uspto.field_patent1 field0, uspto.subfield_patent subfield0, filter_topic1 f0, filter_topic1 f1, openalex_subset_topics_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, subfield en0, field en1
WHERE e2.field_id = field0.id and e0.sibling_id = topic0.id and e1.subfield_id = subfield0.id and e0.sibling_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and f1.id=e0.sibling_id and en0.id=e1.subfield_id and en1.id=e2.field_id;
SELECT f1.name, f2.name, f0.name, f3.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent1 work1, uspto.inventors2 author0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_topic1 f3, openalex_subset_works_topics_final e2
WHERE e2.topic_id = topic0.id and f1.name = work1.name and f0.name = author0.name and f2.name = work0.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.topic_id;
SELECT f0.name, en0.name, f1.name, f2.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent2 topic0, uspto.subfield_patent subfield0, uspto.publication_cited_by_patent2 work1, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and f0.name = work0.name and e2.subfield_id = subfield0.id and f1.name = work1.name and e0.related_work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT f0.name, f3.name, f1.name, f2.name
FROM uspto.inventors author0, uspto.institution1 institution0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1, filter_institution2 f3, openalex_subset_author_institution e2
WHERE f0.name = work0.name and f3.ror = institution0.ror and f2.name = author0.name and e0.related_work_id=e1.work_id and e1.author_id=e2.id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id and f3.id=e2.institution_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.inventors1 author0, uspto.institution1 institution1, uspto.institution1 institution0, filter_author2 f0, filter_institution2 f1, openalex_subset_author_institution e0, filter_institution2 f2, institutions_child_of_institutions e1
WHERE f2.ror = institution0.ror and f1.ror = institution1.ror and f0.name = author0.name and e0.institution_id=e1.institution_id and f0.id=e0.id and f1.id=e0.institution_id and f2.id=e1.associated_institution_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent topic0, uspto.field_patent1 field0, uspto.subfield_patent1 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e2.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT e0.work_id, f2.name, f1.name, f0.name
FROM uspto.inventors author0, uspto.institution1 institution0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1
WHERE f0.name = work0.name and f2.ror = institution0.ror and f1.name = author0.name and e0.author_id=e1.id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id;
SELECT en1.name, f0.name, en0.name, f1.name, e2.work_id
FROM uspto.topic_patent1 topic0, uspto.publication_cited_by_patent work0, uspto.field_patent field0, openalex_subset_subfield_field e0, filter_topic1 f0, openalex_subset_topics_subfield e1, filter_work3 f1, openalex_subset_works_topics_final e2, field en0, subfield en1
WHERE e1.id = topic0.id and f1.name = work0.name and e0.field_id = field0.id and e0.id=e1.subfield_id and e1.id=e2.topic_id and f0.id=e1.id and f1.id=e2.work_id and en0.id=e0.field_id and en1.id=e0.id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent1 topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT f2.name, f0.name, en0.name, f1.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and f1.name = work0.name and e2.subfield_id = subfield0.id and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en1.name, e0.work_id, f1.name, en0.name, f0.name
FROM uspto.publication_cited_by_patent2 work0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en1.name, f0.name, f2.name, en0.name, f1.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent1 topic0, uspto.inventors2 author0, uspto.field_patent field0, uspto.subfield_patent2 subfield0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, openalex_subset_subfield_field e3, field en0, subfield en1
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and e3.field_id = field0.id and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and e2.subfield_id=e3.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e3.field_id and en1.id=e2.subfield_id;
SELECT e0.work_id, f2.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.inventors2 author0, uspto.institution2 institution0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1
WHERE f0.name = work0.name and f2.ror = institution0.ror and f1.name = author0.name and e0.author_id=e1.id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id;
SELECT f0.name, e0.work_id, f3.name, e1.related_work_id, f1.name, f2.name
FROM uspto.topic_patent1 topic0, uspto.inventors1 author0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_topic1 f3, openalex_subset_works_topics_final e2
WHERE e2.topic_id = topic0.id and f0.name = author0.name and f2.name = work0.name and e0.work_id=e1.work_id and e1.related_work_id=e2.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.related_work_id and f3.id=e2.topic_id;
SELECT en0.name, f2.name, f0.name, f1.name
FROM uspto.inventors author0, uspto.topic_patent2 topic0, uspto.publication_cited_by_patent2 work0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_work3 f1, openalex_subset_works_topics_final e1, filter_author2 f2, openalex_subset_works_author e2, keyword en0
WHERE e0.id = topic0.id and f1.name = work0.name and f2.name = author0.name and e0.id=e1.topic_id and e1.work_id=e2.work_id and f0.id=e0.id and f1.id=e1.work_id and f2.id=e2.author_id and en0.name=e0.word;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT en0.name, f0.name, e0.work_id, e1.topic_id, e2.subfield_id, f2.name, f1.name, e0.author_id
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent2 topic0, uspto.inventors1 author0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en1.name, en0.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.field_patent2 field0, uspto.subfield_patent1 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e2.field_id = field0.id and e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT en2.name, en0.name, f0.name, en1.name
FROM uspto.subfield_patent1 subfield0, uspto.subfield_patent1 subfield1, uspto.field_patent field0, filter_topic1 f0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_subfield_field e2, field en0, subfield en1, subfield en2
WHERE e1.field_id = field0.id and e2.id = subfield0.id and e0.subfield_id = subfield1.id and e0.subfield_id=e1.id and e1.field_id=e2.field_id and f0.id=e0.id and en0.id=e1.field_id and en1.id=e2.id and en2.id=e0.subfield_id;
SELECT f1.name, en0.name, e0.work_id, f0.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_keywords_topics e1, keyword en0
WHERE e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.name=e1.word;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent topic0, uspto.field_patent2 field0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and e2.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT e0.work_id, f3.name, f1.name, f2.name, f0.name
FROM uspto.topic_patent topic1, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent2 work0, uspto.publication_cited_by_patent2 work1, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_topic1 f2, openalex_subset_topics_topics e1, filter_work3 f3, openalex_subset_works_topics_final e2
WHERE f3.name = work0.name and e0.topic_id = topic0.id and e1.sibling_id = topic1.id and f0.name = work1.name and e0.topic_id=e1.id and e1.sibling_id=e2.topic_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.sibling_id and f3.id=e2.work_id;
SELECT en1.name, en2.name, en0.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent topic0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, subfield en0, keyword en1, topic en2
WHERE e0.id = topic0.id and e1.subfield_id = subfield0.id and e0.id=e1.id and en0.id=e1.subfield_id and en1.name=e0.word and en2.id=e0.id;
SELECT f1.name, f0.name, f2.name
FROM uspto.institution1 institution1, uspto.inventors2 author0, uspto.institution2 institution0, filter_author2 f0, filter_institution2 f1, openalex_subset_author_institution e0, filter_institution2 f2, institutions_child_of_institutions e1
WHERE f2.ror = institution0.ror and f0.name = author0.name and f1.ror = institution1.ror and e0.institution_id=e1.associated_institution_id and f0.id=e0.id and f1.id=e0.institution_id and f2.id=e1.institution_id;
SELECT en3.name, en2.name, en0.name, en1.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent1 topic0, uspto.field_patent field0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, topic en1, domain en2, subfield en3
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and en0.id=e1.field_id and en1.id=e0.id and en2.id=e2.domain_id and en3.id=e0.subfield_id;
SELECT en2.name, en1.name, en0.name, f0.name
FROM uspto.subfield_patent2 subfield0, uspto.field_patent1 field0, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, domain en1, subfield en2
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and f0.id=e0.id and en0.id=e1.field_id and en1.id=e2.domain_id and en2.id=e0.subfield_id;
SELECT e2.work_id, f3.name, f1.name, f0.name, f2.name
FROM uspto.publication_cited_by_patent work0, uspto.publication_cited_by_patent1 work1, uspto.topic_patent2 topic0, uspto.topic_patent2 topic1, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_topic1 f2, openalex_subset_topics_topics e1, filter_work3 f3, openalex_subset_works_topics_final e2
WHERE f3.name = work0.name and e1.sibling_id = topic0.id and e0.topic_id = topic1.id and f0.name = work1.name and e0.topic_id=e1.id and e1.sibling_id=e2.topic_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.sibling_id and f3.id=e2.work_id;
SELECT f2.ror, f2.name, f1.name, f0.name
FROM uspto.institution1 institution0, uspto.inventors2 author0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1
WHERE f0.name = work0.name and f1.name = author0.name and f2.ror = institution0.ror and e0.author_id=e1.id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id;
SELECT en0.name, f0.name, f3.name, f2.name, f1.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent1 topic0, uspto.subfield_patent subfield0, uspto.publication_cited_by_patent work1, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_topic1 f3, openalex_subset_works_topics_final e2, openalex_subset_topics_subfield e3, subfield en0
WHERE e2.topic_id = topic0.id and f2.name = work1.name and f0.name = work0.name and e3.subfield_id = subfield0.id and e0.related_work_id=e1.work_id and e1.related_work_id=e2.work_id and e2.topic_id=e3.id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.related_work_id and f3.id=e2.topic_id and en0.id=e3.subfield_id;
SELECT en0.name, f2.name, f1.name, f0.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent topic0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, filter_topic1 f2, openalex_subset_topics_topics e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e0.topic_id = topic0.id and e2.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.sibling_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e1.sibling_id and en0.id=e2.subfield_id;
SELECT f2.name, f1.name, e0.work_id, f0.name
FROM uspto.institution1 institution0, uspto.inventors2 author0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1
WHERE f0.name = work0.name and f2.ror = institution0.ror and f1.name = author0.name and e0.author_id=e1.id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id;
SELECT en0.name, f0.name, f1.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent1 topic1, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_topics_subfield e0, filter_topic1 f1, openalex_subset_topics_subfield e1, subfield en0
WHERE e1.id = topic0.id and e0.subfield_id = subfield0.id and e0.id = topic1.id and e0.subfield_id=e1.subfield_id and f0.id=e0.id and f1.id=e1.id and en0.id=e0.subfield_id;
SELECT f1.name, f0.name, f2.name
FROM uspto.inventors1 author0, uspto.institution institution0, uspto.publication_cited_by_patent work0, filter_author2 f0, filter_institution2 f1, openalex_subset_author_institution e0, filter_work3 f2, openalex_subset_works_institution e1
WHERE f2.name = work0.name and f1.ror = institution0.ror and f0.name = author0.name and e0.institution_id=e1.institution_id and f0.id=e0.id and f1.id=e0.institution_id and f2.id=e1.work_id;
SELECT f0.name, f1.name, f2.name
FROM uspto.publication_cited_by_patent work0, uspto.publication_cited_by_patent work1, uspto.topic_patent topic0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_works_topics_final e2
WHERE e1.topic_id = topic0.id and f0.name = work1.name and f1.name = work0.name and e0.work_id=e1.work_id and e0.related_work_id=e2.work_id and e1.topic_id=e2.topic_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.topic_id;
SELECT f2.name, f1.name, e0.work_id, f3.name, f0.name
FROM uspto.institution1 institution1, uspto.publication_cited_by_patent work0, uspto.inventors2 author0, uspto.institution1 institution0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1, filter_institution2 f3, institutions_child_of_institutions e2
WHERE f3.ror = institution0.ror and f0.name = work0.name and f1.name = author0.name and f2.ror = institution1.ror and e0.author_id=e1.id and e1.institution_id=e2.associated_institution_id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id and f3.id=e2.institution_id;
SELECT f1.name, en0.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT en1.name, en0.name, f0.name, f1.name
FROM uspto.topic_patent1 topic0, uspto.publication_cited_by_patent work0, uspto.field_patent2 field0, openalex_subset_subfield_field e0, filter_topic1 f0, openalex_subset_topics_subfield e1, filter_work3 f1, openalex_subset_works_topics_final e2, field en0, subfield en1
WHERE e0.field_id = field0.id and e1.id = topic0.id and f1.name = work0.name and e0.id=e1.subfield_id and e1.id=e2.topic_id and f0.id=e1.id and f1.id=e2.work_id and en0.id=e0.field_id and en1.id=e0.id;
SELECT f0.name, f1.name, f3.name, f2.name
FROM uspto.topic_patent2 topic0, uspto.inventors1 author0, uspto.publication_cited_by_patent2 work0, uspto.institution institution0, filter_institution2 f0, filter_author2 f1, openalex_subset_author_institution e0, filter_work3 f2, openalex_subset_works_author e1, filter_topic1 f3, openalex_subset_works_topics_final e2
WHERE e2.topic_id = topic0.id and f2.name = work0.name and f1.name = author0.name and f0.ror = institution0.ror and e0.id=e1.author_id and e1.work_id=e2.work_id and f0.id=e0.institution_id and f1.id=e0.id and f2.id=e1.work_id and f3.id=e2.topic_id;
SELECT en2.name, f1.name, en0.name, en1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.publication_cited_by_patent2 work0, uspto.field_patent field0, uspto.subfield_patent subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, openalex_subset_field_domain e3, domain en0, field en1, subfield en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and e2.field_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e3.domain_id and en1.id=e2.field_id and en2.id=e1.subfield_id;
SELECT en2.name, f1.name, en0.name, en1.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.field_patent field0, uspto.subfield_patent1 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, openalex_subset_field_domain e3, domain en0, field en1, subfield en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id = topic0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and e2.field_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e3.domain_id and en1.id=e2.field_id and en2.id=e1.subfield_id;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.inventors author0, uspto.subfield_patent1 subfield0, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e2.subfield_id = subfield0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT en0.name, f0.name, f2.name, f1.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.inventors1 author0, uspto.subfield_patent1 subfield0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, subfield en0
WHERE e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.id=e2.subfield_id;
SELECT e0.work_id, f2.name, f1.name, f0.name
FROM uspto.inventors author0, uspto.institution1 institution0, uspto.publication_cited_by_patent work0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1
WHERE f0.name = work0.name and f2.ror = institution0.ror and f1.name = author0.name and e0.author_id=e1.id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id;
SELECT f3.name, f0.name, f2.name, en0.name, f1.name
FROM uspto.inventors author0, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, uspto.subfield_patent2 subfield0, uspto.institution2 institution0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_topics_subfield e2, filter_institution2 f3, openalex_subset_author_institution e3, subfield en0
WHERE f3.ror = institution0.ror and e1.topic_id = topic0.id and e2.subfield_id = subfield0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and e0.author_id=e3.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and f3.id=e3.institution_id and en0.id=e2.subfield_id;
SELECT en0.name, f3.name, f2.name, f0.name, f1.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent2 topic0, uspto.inventors1 author0, uspto.institution1 institution0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_work3 f1, openalex_subset_works_topics_final e1, filter_author2 f2, openalex_subset_works_author e2, filter_institution2 f3, openalex_subset_author_institution e3, keyword en0
WHERE e0.id = topic0.id and f1.name = work0.name and f2.name = author0.name and f3.ror = institution0.ror and e0.id=e1.topic_id and e1.work_id=e2.work_id and e2.author_id=e3.id and f0.id=e0.id and f1.id=e1.work_id and f2.id=e2.author_id and f3.id=e3.institution_id and en0.name=e0.word;
SELECT en0.name, f0.name, f1.name
FROM uspto.topic_patent1 topic1, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT f2.name, f1.name, e0.work_id, e1.institution_id, f0.name, e0.work_id, e0.author_id
FROM uspto.institution1 institution0, uspto.inventors2 author0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1
WHERE f0.name = work0.name and f2.ror = institution0.ror and f1.name = author0.name and e0.author_id=e1.id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id;
SELECT en1.name, f1.name, en0.name, f0.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent2 topic0, uspto.field_patent2 field0, uspto.subfield_patent subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, subfield en0, field en1
WHERE e2.field_id = field0.id and e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e1.subfield_id and en1.id=e2.field_id;
SELECT en2.name, en0.name, e0.id, e1.subfield_id, f0.name, en1.name, e2.field_id
FROM uspto.subfield_patent1 subfield0, uspto.field_patent1 field0, uspto.topic_patent topic0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, keyword en0, field en1, subfield en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and en0.name=e0.word and en1.id=e2.field_id and en2.id=e1.subfield_id;
SELECT en0.name, f1.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.topic_patent1 topic1, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_topic1 f1, openalex_subset_topics_topics e1, keyword en0
WHERE e1.sibling_id = topic0.id and e0.id = topic1.id and e0.id=e1.id and f0.id=e0.id and f1.id=e1.sibling_id and en0.name=e0.word;
SELECT en1.name, en2.name, en0.name, f0.name
FROM uspto.subfield_patent2 subfield0, uspto.topic_patent topic0, uspto.field_patent2 field0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, keyword en1, subfield en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and en0.id=e2.field_id and en1.name=e0.word and en2.id=e1.subfield_id;
SELECT en0.name, f2.name, f1.name, f3.name, f0.name
FROM uspto.topic_patent1 topic0, uspto.inventors2 author0, uspto.publication_cited_by_patent2 work0, uspto.institution2 institution0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1, filter_topic1 f3, openalex_subset_works_topics_final e2, openalex_subset_keywords_topics e3, keyword en0
WHERE e2.topic_id = topic0.id and f0.name = work0.name and f1.name = author0.name and f2.ror = institution0.ror and e0.author_id=e1.id and e0.work_id=e2.work_id and e2.topic_id=e3.id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id and f3.id=e2.topic_id and en0.name=e3.word;
SELECT en0.name, f2.name, e1.work_id, e0.id, f0.name, f1.name, e2.author_id
FROM uspto.topic_patent1 topic0, uspto.inventors1 author0, uspto.publication_cited_by_patent1 work0, filter_topic1 f0, openalex_subset_keywords_topics e0, filter_work3 f1, openalex_subset_works_topics_final e1, filter_author2 f2, openalex_subset_works_author e2, keyword en0
WHERE e0.id = topic0.id and f1.name = work0.name and f2.name = author0.name and e0.id=e1.topic_id and e1.work_id=e2.work_id and f0.id=e0.id and f1.id=e1.work_id and f2.id=e2.author_id and en0.name=e0.word;
SELECT e0.author_id, en0.name, f0.name
FROM uspto.inventors author0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent2 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, openalex_subset_keywords_topics e2, keyword en0
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and en0.name=e2.word;
SELECT f0.name, f2.name, f1.name
FROM uspto.topic_patent1 topic0, uspto.inventors1 author0, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT f0.name, f1.name, f2.name, e2.related_work_id, f3.name
FROM uspto.publication_cited_by_patent work0, uspto.inventors2 author0, uspto.institution1 institution0, filter_institution2 f0, filter_author2 f1, openalex_subset_author_institution e0, filter_work3 f2, openalex_subset_works_author e1, filter_work3 f3, openalex_subset_works_related_works e2
WHERE f2.name = work0.name and f1.name = author0.name and f0.ror = institution0.ror and e0.id=e1.author_id and e1.work_id=e2.work_id and f0.id=e0.institution_id and f1.id=e0.id and f2.id=e1.work_id and f3.id=e2.related_work_id;
SELECT en2.name, e0.work_id, f1.name, en0.name, en1.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent2 topic0, uspto.field_patent2 field0, uspto.subfield_patent1 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, openalex_subset_field_domain e3, domain en0, field en1, subfield en2
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e2.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and e2.field_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e3.domain_id and en1.id=e2.field_id and en2.id=e1.subfield_id;
SELECT en1.name, en2.name, en0.name, f0.name
FROM uspto.subfield_patent1 subfield0, uspto.topic_patent2 topic0, uspto.field_patent1 field0, filter_topic1 f0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, keyword en1, subfield en2
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and f0.id=e0.id and en0.id=e2.field_id and en1.name=e0.word and en2.id=e1.subfield_id;
SELECT en1.name, en0.name, f1.name, f0.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent topic0, uspto.field_patent field0, uspto.subfield_patent2 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, subfield en1
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e2.field_id = field0.id and e0.topic_id=e1.id and e1.subfield_id=e2.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e2.field_id and en1.id=e1.subfield_id;
SELECT f1.name, f0.name, f3.name, f2.name
FROM uspto.inventors author0, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, uspto.institution2 institution0, filter_author2 f0, filter_institution2 f1, openalex_subset_author_institution e0, filter_work3 f2, openalex_subset_works_institution e1, filter_topic1 f3, openalex_subset_works_topics_final e2
WHERE e2.topic_id = topic0.id and f2.name = work0.name and f0.name = author0.name and f1.ror = institution0.ror and e0.institution_id=e1.institution_id and e1.work_id=e2.work_id and f0.id=e0.id and f1.id=e0.institution_id and f2.id=e1.work_id and f3.id=e2.topic_id;
SELECT en2.name, f1.name, en0.name, en1.name, f0.name
FROM uspto.topic_patent2 topic0, uspto.publication_cited_by_patent work0, uspto.field_patent2 field0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, openalex_subset_field_domain e3, domain en0, field en1, subfield en2
WHERE e2.field_id = field0.id and e0.topic_id = topic0.id and f0.name = work0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and e2.field_id=e3.id and f0.id=e0.work_id and f1.id=e0.topic_id and en0.id=e3.domain_id and en1.id=e2.field_id and en2.id=e1.subfield_id;
SELECT f3.name, f0.name, f2.name, f1.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent topic0, uspto.topic_patent2 topic1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, filter_topic1 f3, openalex_subset_topics_topics e2
WHERE e1.topic_id = topic0.id and e2.sibling_id = topic1.id and f1.name = work0.name and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and f3.id=e2.sibling_id;
SELECT f0.name, f2.name, f1.cited_by_count, f1.name
FROM uspto.inventors author0, uspto.topic_patent1 topic0, uspto.publication_cited_by_patent work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE e1.topic_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;
SELECT f3.name, f0.name, f2.name, f1.name
FROM uspto.publication_cited_by_patent work0, uspto.topic_patent1 topic0, uspto.inventors1 author0, uspto.topic_patent1 topic1, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1, filter_topic1 f3, openalex_subset_topics_topics e2
WHERE e2.sibling_id = topic0.id and f1.name = work0.name and f0.name = author0.name and e1.topic_id = topic1.id and e0.work_id=e1.work_id and e1.topic_id=e2.id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id and f3.id=e2.sibling_id;
SELECT e0.work_id, f2.name, f1.name, f0.name
FROM uspto.inventors1 author0, uspto.institution2 institution0, uspto.publication_cited_by_patent2 work0, filter_work3 f0, filter_author2 f1, openalex_subset_works_author e0, filter_institution2 f2, openalex_subset_author_institution e1
WHERE f0.name = work0.name and f2.ror = institution0.ror and f1.name = author0.name and e0.author_id=e1.id and f0.id=e0.work_id and f1.id=e0.author_id and f2.id=e1.institution_id;
SELECT f0.name, f1.name, f3.name, f2.name
FROM uspto.topic_patent2 topic0, uspto.inventors2 author0, uspto.publication_cited_by_patent2 work0, uspto.institution institution0, filter_institution2 f0, filter_author2 f1, openalex_subset_author_institution e0, filter_work3 f2, openalex_subset_works_author e1, filter_topic1 f3, openalex_subset_works_topics_final e2
WHERE e2.topic_id = topic0.id and f2.name = work0.name and f0.ror = institution0.ror and f1.name = author0.name and e0.id=e1.author_id and e1.work_id=e2.work_id and f0.id=e0.institution_id and f1.id=e0.id and f2.id=e1.work_id and f3.id=e2.topic_id;
SELECT en0.name, f2.name, f0.name
FROM uspto.publication_cited_by_patent1 work0, uspto.topic_patent2 topic0, uspto.inventors1 author0, uspto.field_patent2 field0, uspto.subfield_patent2 subfield0, filter_work3 f0, filter_topic1 f1, openalex_subset_works_topics_final e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, filter_author2 f2, openalex_subset_works_author e3, field en0
WHERE e0.topic_id = topic0.id and e1.subfield_id = subfield0.id and f0.name = work0.name and e2.field_id = field0.id and f2.name = author0.name and e0.topic_id=e1.id and e1.subfield_id=e2.id and e0.work_id=e3.work_id and f0.id=e0.work_id and f1.id=e0.topic_id and f2.id=e3.author_id and en0.id=e2.field_id;
SELECT f0.name, f3.name, f2.name, f4.name, f1.name
FROM uspto.publication_cited_by_patent work2, uspto.topic_patent topic0, uspto.publication_cited_by_patent2 work0, uspto.topic_patent2 topic1, uspto.publication_cited_by_patent work1, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_work3 f2, openalex_subset_works_related_works e1, filter_topic1 f3, openalex_subset_works_topics_final e2, filter_topic1 f4, openalex_subset_topics_topics e3
WHERE f0.name = work1.name and e3.id = topic0.id and e2.topic_id = topic1.id and f1.name = work2.name and f2.name = work0.name and e0.related_work_id=e1.related_work_id and e0.work_id=e2.work_id and e2.topic_id=e3.sibling_id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.work_id and f3.id=e2.topic_id and f4.id=e3.id;
SELECT en2.name, en1.name, en0.name, f0.name
FROM uspto.topic_patent topic0, uspto.subfield_patent subfield0, uspto.field_patent field0, filter_topic1 f0, openalex_subset_topics_subfield e0, openalex_subset_subfield_field e1, openalex_subset_field_domain e2, field en0, domain en1, subfield en2
WHERE e1.field_id = field0.id and e0.subfield_id = subfield0.id and e0.id = topic0.id and e0.subfield_id=e1.id and e1.field_id=e2.id and f0.id=e0.id and en0.id=e1.field_id and en1.id=e2.domain_id and en2.id=e0.subfield_id;
SELECT f3.name, f2.name, f0.name, e0.related_work_id, e0.work_id, f1.name
FROM uspto.inventors author0, uspto.institution1 institution0, uspto.publication_cited_by_patent1 work0, filter_work3 f0, filter_work3 f1, openalex_subset_works_related_works e0, filter_author2 f2, openalex_subset_works_author e1, filter_institution2 f3, openalex_subset_author_institution e2
WHERE f0.name = work0.name and f3.ror = institution0.ror and f2.name = author0.name and e0.related_work_id=e1.work_id and e1.author_id=e2.id and f0.id=e0.work_id and f1.id=e0.related_work_id and f2.id=e1.author_id and f3.id=e2.institution_id;
SELECT en1.name, en3.name, en0.name, en2.name
FROM uspto.topic_patent1 topic0, uspto.field_patent1 field0, uspto.subfield_patent subfield0, openalex_subset_keywords_topics e0, openalex_subset_topics_subfield e1, openalex_subset_subfield_field e2, field en0, keyword en1, topic en2, subfield en3
WHERE e2.field_id = field0.id and e1.subfield_id = subfield0.id and e0.id = topic0.id and e0.id=e1.id and e1.subfield_id=e2.id and en0.id=e2.field_id and en1.name=e0.word and en2.id=e0.id and en3.id=e1.subfield_id