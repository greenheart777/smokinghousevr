using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CigarCollision : MonoBehaviour
{
    [SerializeField] private GameObject Main;
    [SerializeField] private GameObject CigarBurning;
    [SerializeField] private ParticleSystem _SmokeParticle;
    private int _colInt = 0;

    [SerializeField] private AudioSource _audioSource;
    [SerializeField] private AudioClip CigarPutOut_1;
    [SerializeField] private AudioClip CigarPutOut_2;

    private void OnTriggerEnter(Collider other)
    {
        if (other.name == "CigarTrigger")
        {
            Main.GetComponent<Cigar>()._isZippo = true;
        }
        if (other.name == "AshtrayTrigger")
        {
            if (Main.GetComponent<Cigar>()._isFire == true)
            {
                _colInt += 1;
                _audioSource.PlayOneShot(CigarPutOut_1);

                if (_colInt == 3)
                {
                    _SmokeParticle.Stop();
                    CigarBurning.SetActive(false);
                    _colInt = 0;
                    _audioSource.PlayOneShot(CigarPutOut_2);
                    Main.GetComponent<Cigar>()._isFire = false;
                }
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.name == "CigarTrigger")
        {
            Main.GetComponent<Cigar>()._isZippo = false;
        }
    }

    /**private void OnCollisionEnter(Collision collision)
    {
        StartCoroutine(CigarPulOut());
    }

    IEnumerator CigarPulOut()
    {
        if (Main.GetComponent<Cigar>()._isFire == true)
        {
            _colInt += 1;
            _audioSource.PlayOneShot(CigarPutOut_1);

            if (_colInt == 3)
            {
                _SmokeParticle.Stop();
                CigarBurning.SetActive(false);
                _colInt = 0;
                _audioSource.PlayOneShot(CigarPutOut_2);
                Main.GetComponent<Cigar>()._isFire = false;
            }
        }
        yield return null;
    }**/
}
