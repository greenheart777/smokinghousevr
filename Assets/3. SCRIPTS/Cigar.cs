using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Cigar : MonoBehaviour
{
    [SerializeField] private GameObject _Smoke;
    [SerializeField] private GameObject CigarBurning;
    [SerializeField] private ParticleSystem _SmokeParticle;
    [SerializeField] private ParticleSystem _PlayerSmokeParticle;
    [SerializeField] private AudioSource _AudioSource;
    [SerializeField] private AudioClip _CigaretteInhale;
    [SerializeField] private AudioClip _CigaretteDrage;

    public bool _isFire = false;
    public bool _isZippo = false;
    private bool _isHead = false;
    private bool _isTimeSmoking = false;

    private int _colInt = 0;
    private float _timeInhale;
    private float _timeExhale;
    public TMP_Text _text;


    private void Start()
    {
        _Smoke.SetActive(true);
        _SmokeParticle.Stop();
        _PlayerSmokeParticle.Stop();
        _isFire = false;
        _isZippo = false;
        _isHead = false;
        CigarBurning.SetActive(false);
        _text.text = _isFire.ToString();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.name == "PlayerHeadSmokingTrigger")
        {
            _isHead = true;
            _text.text = "In Head";
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.name == "PlayerHeadSmokingTrigger")
        {
            _isHead = false;
            _text.text = "Out of Head";
        }
    }

    public void Inhale()
    {
        if(_isHead == true)
        {
            if (_isZippo == true)
            {
                _isFire = true;
                CigarBurning.SetActive(true);
            }

            if (_isFire == true)
            {
                _timeInhale = Time.fixedTime;
                _isTimeSmoking = true;
                _SmokeParticle.Stop();
                _AudioSource.PlayOneShot(_CigaretteInhale);
            }
        }
    }
    public void Exhale()
    {
        if (_isTimeSmoking == true)
        {
            if (_isFire == true)
            {
                _timeExhale = Time.fixedTime;
                //_text.text += " Exhale = " + _timeExhale;
                //_text.text += " RES = " + (_timeExhale - _timeInhale);
                _SmokeParticle.Play();
                _AudioSource.Stop();
                _AudioSource.PlayOneShot(_CigaretteDrage);
                StartCoroutine(ExhaleCoroutine());
                _isTimeSmoking = false;
            }
        }
    }

    IEnumerator ExhaleCoroutine()
    {
        yield return new WaitForSeconds(0.1f);
        _PlayerSmokeParticle.Play();
        yield return new WaitForSeconds(_timeExhale - _timeInhale);
        _PlayerSmokeParticle.Stop();
        _AudioSource.Stop();
        yield return null;
    }
}
